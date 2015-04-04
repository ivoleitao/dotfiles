#!/bin/bash

source "$(dirname $0)/config.sh"

format_distro() {
    local value=$1    
    local icon="$DISTRO_ICON"
    local icon_color="$DISTRO_NORMAL_ICON_COLOR"    

    if [ $value -gt 0 ]; then
        icon_color="$DISTRO_WARN_ICON_COLOR"
    fi

    echo "<span foreground='$icon_color'>$icon</span> $value"
}

panel_distro() {
    local value="$(apt-get -s upgrade | awk '/Inst.+/ {print $2}' | wc -l)"
       
    echo "$(format_distro "$value")"
}

echo $(panel_distro)
