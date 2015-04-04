#!/bin/bash

source "$(dirname $0)/config.sh"

format_message() {
    local value=$1
    value="${value:-0}"
    local icon="$MESSAGE_NORMAL_ICON"
    local icon_color="$MESSAGE_NORMAL_ICON_COLOR"    

    if [ $value -gt 0 ]; then
        icon="$MESSAGE_WARN_ICON" 
        icon_color="$MESSAGE_WARN_ICON_COLOR"
    fi

    echo "<span foreground='$icon_color'>$icon</span> $value"
}

panel_message() {
    local value=0
    local windows=($(purple-send PurpleGetConversations 2>/dev/null | awk '/int32/{ print $2 }'))
    local unseen=0

    for winid in "${windows[@]}"; do
        unseen=$(purple-send PurpleConversationGetUnseen int32:$winid 2>/dev/null | awk '/int32/ { print $2 }') 
        value=$((value + unseen))
    done

    echo "$(format_message "$value")"
}

echo $(panel_message)
