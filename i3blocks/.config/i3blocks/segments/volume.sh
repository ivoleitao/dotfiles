#!/bin/bash

source "$(dirname $0)/config.sh"

format_volume() {
    local value=$1
    local icon=""

    if [ $value -eq 0 ]
    then
        icon="$VOLUME_ICON_MIN"
    elif [ $value -le 30 ] 
    then
        icon="$VOLUME_ICON_LOW"
    elif [ $value -le 60 ]
    then
        icon="$VOLUME_ICON_MEDIUM"
    elif [ $value -lt 100 ]
    then
        icon="$VOLUME_ICON_HIGH"
    elif [ $value -eq 100 ]
    then
        icon="$VOLUME_ICON_MAX"
    fi

    printf "<span foreground='$VOLUME_ICON_COLOR'>$icon</span> %-3s" "$value%"
}

panel_volume() {
    local value="0"
    local status="$(amixer get Master|tail -n1|sed -E 's/.*\[([a-z]+)\]/\1/')"
    if [[ $status == "on" ]]; then
        value="$(amixer get Master|tail -n1|sed -E 's/.*\[([0-9]+)\%\].*/\1/')"
    fi

    echo "$(format_volume "$value")"
}

echo $(panel_volume)
