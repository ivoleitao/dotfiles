#!/bin/bash

source "$(dirname $0)/config.sh"

format_clock() {
    local value=$1    
    local hour=$(date +%I)
    local icon=""

    case "$hour" in
        "01")
            icon=$CLOCK_ICON_01
            ;;
        "02")
            icon=$CLOCK_ICON_02
            ;;
        "03")
            icon=$CLOCK_ICON_03
            ;;
        "04")
            icon=$CLOCK_ICON_04
            ;;
        "05")
            icon=$CLOCK_ICON_05
            ;;
        "06")
            icon=$CLOCK_ICON_06
            ;;
        "07")
            icon=$CLOCK_ICON_07
            ;;
        "08")
            icon=$CLOCK_ICON_08
            ;;
        "09")
            icon=$CLOCK_ICON_09
            ;;
        "10")
            icon=$CLOCK_ICON_10
            ;;
        "11")
            icon=$CLOCK_ICON_11
            ;;
        "12")
            icon=$CLOCK_ICON_12
    esac

    echo "<span foreground='$CLOCK_ICON_COLOR'>$icon</span> $value"
}

panel_clock() {
    local value=$(date +$CLOCK_FORMAT)

    echo "$(format_clock "$value")"
}

echo $(panel_clock)
