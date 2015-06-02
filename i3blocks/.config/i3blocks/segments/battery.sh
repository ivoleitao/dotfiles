#!/bin/bash

source "$(dirname $0)/config.sh"

format_battery() {
    local value=$1
    local icon=""
    local icon_color=""

    if [ $value -le $BATTERY_ICON_CRITICAL_THRESHOLD ]
    then
        icon="$BATTERY_ICON_CRITICAL"
        icon_color="$BATTERY_ICON_CRITICAL_COLOR"
    elif [ $value -le $BATTERY_ICON_VERY_LOW_THRESHOLD ] 
    then
        icon="$BATTERY_ICON_VERY_LOW"
        icon_color="$BATTERY_ICON_VERY_LOW_COLOR"
    elif [ $value -le $BATTERY_ICON_LOW_THRESHOLD ] 
    then
        icon="$BATTERY_ICON_LOW"
        icon_color="$BATTERY_ICON_LOW_COLOR"
    elif [ $value -le $BATTERY_ICON_MEDIUM_THRESHOLD ]
    then
        icon="$BATTERY_ICON_MEDIUM"
        icon_color="$BATTERY_ICON_MEDIUM_COLOR"
    elif [ $value -le $BATTERY_ICON_HIGH_THRESHOLD ]
    then
        icon="$BATTERY_ICON_HIGH"
        icon_color="$BATTERY_ICON_HIGH_COLOR"
    elif [ $value -le $BATTERY_ICON_VERY_HIGH_THRESHOLD ]
    then
        icon="$BATTERY_ICON_VERY_HIGH"
        icon_color="$BATTERY_ICON_VERY_HIGH_COLOR"
    elif [ $value -lt $BATTERY_ICON_MAX_THRESHOLD ]
    then
        icon="$BATTERY_ICON_MAX"
        icon_color="$BATTERY_ICON_MAX_COLOR"
    elif [ $value -eq $BATTERY_ICON_MAX_THRESHOLD ]
    then
        icon="$BATTERY_ICON_FULL"
        icon_color="$BATTERY_ICON_FULL_COLOR"
    fi

    printf "<span foreground='$icon_color'>$icon</span> %-3s" "$value%"
}

panel_battery() {
    local bat_path=/sys/class/power_supply/BAT0
    if [ ! -d $bat_path ]; then
        bat_path=/sys/class/power_supply/BAT1
    fi

    local bat_full_path=$bat_path/charge_full
    if [ ! -r $bat_full_path ]; then
        bat_full_path=$bat_path/energy_full
    fi
    local bat_now_path=$bat_path/charge_now
    if [ ! -r $bat_now_path ]; then
        bat_now_path=$bat_path/energy_now
    fi

    local full=$(cat $bat_full_path)
    local current=$(cat $bat_now_path)
    local value=$((100*$current/$full))

    echo "$(format_battery "$value")"
}

echo $(panel_battery)
