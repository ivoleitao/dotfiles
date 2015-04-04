#!/bin/bash

source "$(dirname $0)/config.sh"

format_disk_usage() {
    local value=$1
    local icon="$DISK_USAGE_ICON"

    printf "<span foreground='$DISK_USAGE_ICON_COLOR'>$icon</span> %-3s" "$value%"
}

panel_disk_usage() {
    value="$(df -h --total | tail -1 | awk '{print +$5}')"

    echo "$(format_disk_usage "$value")"
}

echo "$(panel_disk_usage)"
