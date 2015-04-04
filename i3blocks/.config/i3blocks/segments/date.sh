#!/bin/bash

source "$(dirname $0)/config.sh"

format_date() {
    local value=$1    
    local icon="$DATE_ICON"

    echo "<span foreground='$DATE_ICON_COLOR'>$icon</span> $value"
}

panel_date() {
    local value=$(date +$DATE_FORMAT)

    echo "$(format_date "$value")"
}

echo $(panel_date)
