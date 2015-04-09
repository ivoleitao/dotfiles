#!/bin/bash

source "$(dirname $0)/config.sh"

format_volume() {
    local status=$1
    local volume=$2
    local icon=""

    if [[ "$status" == "off" ]]; then
        icon="$VOLUME_ICON_MUTE"
    elif [[ "$status" == "on" ]]; then
        if [ $volume -eq 0 ]
        then
            icon="$VOLUME_ICON_MIN"
        elif [ $volume -le 30 ] 
        then
            icon="$VOLUME_ICON_LOW"
        elif [ $volume -le 60 ]
        then
            icon="$VOLUME_ICON_MEDIUM"
        elif [ $volume -lt 100 ]
        then
            icon="$VOLUME_ICON_HIGH"
        elif [ $volume -eq 100 ]
        then
            icon="$VOLUME_ICON_MAX"
        fi
    fi

    printf "<span foreground='$VOLUME_ICON_COLOR'>$icon</span> %-3s" "$volume%"
}

panel_volume() {
    local status="$(amixer get Master|tail -n1|sed -E 's/.*\[([a-z]+)\]/\1/')"
    local volume="$(amixer get Master|tail -n1|sed -E 's/.*\[([0-9]+)\%\].*/\1/')"
    echo "$(format_volume "$status" "$volume")"
}

echo $(panel_volume)
