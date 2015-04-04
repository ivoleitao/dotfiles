#!/bin/bash

source "$(dirname $0)/config.sh"

format_backlight() {
    local value=$1
    local icon=""

    if [ $value -le 20 ] 
    then
        icon="$BACKLIGHT_ICON_LOW"
    elif [ $value -le 60 ]
    then
        icon="$BACKLIGHT_ICON_MEDIUM"
    elif [ $value -lt 100 ]
    then
        icon="$BACKLIGHT_ICON_HIGH"
    elif [ $value -eq 100 ]
    then
        icon="$BACKLIGHT_ICON_MAX"
    fi

    printf "<span foreground='$BACKLIGHT_ICON_COLOR'>$icon</span> %-3s" "$value%"
}

panel_backlight() {
    value=$(xbacklight | awk '{printf("%d\n",$1 + 0.5)}')

    echo "$(format_backlight "$value")"
}

echo "$(panel_backlight)"
