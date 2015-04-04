#!/bin/bash

source "kv-shell.sh"
source "$(dirname $0)/config.sh"

format_battery() {
    local value=$1
    local icon=""

    if [ $value -le 5 ]
    then
        icon="$BATTERY_ICON_CRITICAL"
    elif [ $value -le 10 ] 
    then
        icon="$BATTERY_ICON_VERY_LOW"
    elif [ $value -le 20 ] 
    then
        icon="$BATTERY_ICON_LOW"
    elif [ $value -le 40 ]
    then
        icon="$BATTERY_ICON_MEDIUM"
    elif [ $value -le 60 ]
    then
        icon="$BATTERY_ICON_HIGH"
    elif [ $value -le 80 ]
    then
        icon="$BATTERY_ICON_VERY_HIGH"
    elif [ $value -lt 100 ]
    then
        icon="$BATTERY_ICON_MAX"
    elif [ $value -eq 100 ]
    then
        icon="$BATTERY_ICON_FULL"
    fi

    printf "<span foreground='$BATTERY_ICON_COLOR'>$icon</span> %-3s" "$value%"
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
