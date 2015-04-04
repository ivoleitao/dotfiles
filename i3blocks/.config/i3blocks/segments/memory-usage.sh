#!/bin/bash

source "$(dirname $0)/config.sh"

format_memory_usage() {
    local value=$1
    local icon="$MEMORY_USAGE_ICON"

    printf "<span foreground='$MEMORY_USAGE_ICON_COLOR'>$icon</span> %-3s" "$value%"
}

panel_memory_usage() {
    local total_memory=$(free -m | sed -n 2p| awk '{print $2}')
    local used_memory=$(free -m | sed -n 3p| awk '{print $3}')
    local value="$(echo "$used_memory*100/$total_memory" | bc)"

    echo "$(format_memory_usage "$value")"
}

echo "$(panel_memory_usage)"
