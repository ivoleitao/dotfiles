#!/bin/bash

source "$(dirname $0)/config.sh"

format_wireless() {
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
    elif [ $value -le 100 ]
    then
        icon="$BATTERY_ICON_MAX"
    elif [ $value -eq 100 ]
    then
        icon="$BATTERY_ICON_FULL"
    fi

    printf "<span foreground='$BATTERY_ICON_COLOR'>$icon</span> %-3s" "$value%"
}

format_wired() {
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
    elif [ $value -le 100 ]
    then
        icon="$BATTERY_ICON_MAX"
    elif [ $value -eq 100 ]
    then
        icon="$BATTERY_ICON_FULL"
    fi

    printf "<span foreground='$BATTERY_ICON_COLOR'>$icon</span> %-3s" "$value%"
}

panel_network() {

    echo "$(format_network "$value")"
}

echo $(panel_network)
