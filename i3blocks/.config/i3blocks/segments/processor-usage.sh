#!/bin/bash

source "/home/ivoleitao/lib/kv-shell.sh"
source "$(dirname $0)/config.sh"

format_processor_usage() {
    local value=$1
    local icon="$PROCESSOR_USAGE_ICON"
    local icon_color="$PROCESSOR_USAGE_ICON_NORMAL_COLOR"

    if [ $value -ge $PROCESSOR_USAGE_ICON_CRITICAL_COLOR_THRESHOLD ]
    then
        icon_color="$PROCESSOR_USAGE_ICON_CRITICAL_COLOR"
    elif [ $value -ge $PROCESSOR_USAGE_ICON_ALERT_COLOR_THRESHOLD ] 
    then
        icon_color="$PROCESSOR_USAGE_ICON_ALERT_COLOR"
    elif [ $value -ge $PROCESSOR_USAGE_ICON_WARN_COLOR_THRESHOLD ] 
    then
        icon_color="$PROCESSOR_USAGE_ICON_WARN_COLOR"
    fi

    printf "<span foreground='$icon_color'>$icon</span> %-3s" "$value%"
}

panel_processor_usage() {
    local prev_idle_key="panel_processor_usage_prev_idle"
    local prev_total_key="panel_processor_usage_prev_total"
    local prev_idle_value=$(kvget $prev_idle_key)
    prev_idle_value=${prev_idle_value:-0}
    local prev_total_value=$(kvget $prev_total_key)
    prev_total_value=${prev_total_value:-0}

    # Get the total processor statistics, discarding the 'cpu ' prefix.
    local processor_statistics=(`sed -n 's/^cpu\s//p' /proc/stat`)
    # Get the processor idle time.
    local processor_idle=${processor_statistics[3]} 
    # Calculate the total processor time.
    local processor_total=0
    for processor_value in "${processor_statistics[@]}"; do
        let "processor_total=$processor_total+$processor_value"
    done
    # Calculate the processor usage since we last checked.
    let "diff_processor_idle=$processor_idle-$prev_idle_value"
    let "diff_processor_total=$processor_total-$prev_total_value"
    let "value=(1000*($diff_processor_total-$diff_processor_idle)/$diff_processor_total+5)/10"
    # Remember the total and idle processor times for the next check.
    kvset $prev_idle_key "$processor_idle"
    kvset $prev_total_key "$processor_total"

    echo "$(format_processor_usage "$value")"
}

echo "$(panel_processor_usage)"
