#!/bin/bash

source "$(dirname $0)/config.sh"

format_mail() {
    local value=$1
    local icon="$MAIL_NORMAL_ICON"
    local icon_color="$MAIL_NORMAL_ICON_COLOR"    

    if [ $value -gt 0 ]; then
        icon="$MAIL_WARN_ICON" 
        icon_color="$MAIL_WARN_ICON_COLOR"
    fi

    echo "<span foreground='$icon_color'>$icon</span> $value"
}

panel_mail() {
    local value=$(mailcheck -bsc | awk '{sum+=$2} END {print sum}')

    echo "$(format_mail "$value")"
}

echo $(panel_mail)
