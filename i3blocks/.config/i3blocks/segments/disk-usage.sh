#!/bin/bash

source "$(dirname $0)/config.sh"

format_disk_usage() {
    local value=$1
    local icon="$DISK_USAGE_ICON"
    local icon_color="$DISK_USAGE_ICON_NORMAL_COLOR"

    if [ $value -ge $DISK_USAGE_ICON_CRITICAL_COLOR_THRESHOLD ]
    then
        icon_color="$DISK_USAGE_ICON_CRITICAL_COLOR"
    elif [ $value -ge $DISK_USAGE_ICON_ALERT_COLOR_THRESHOLD ] 
    then
        icon_color="$DISK_USAGE_ICON_ALERT_COLOR"
    elif [ $value -ge $DISK_USAGE_ICON_WARN_COLOR_THRESHOLD ] 
    then
        icon_color="$DISK_USAGE_ICON_WARN_COLOR"
    fi

    printf "<span foreground='$icon_color'>$icon</span> %-3s" "$value%"
}

panel_disk_usage() {
    value="$(df -h $DISK_USAGE_FILESYSTEM | tail -1 | awk '{print +$5}')"

    echo "$(format_disk_usage "$value")"
}

echo "$(panel_disk_usage)"






