#!/bin/bash

source "$(dirname $0)/config.sh"

format_wired() {
    local interface=$1
    printf "<span foreground='$NETWORK_ICON_COLOR'>$NETWORK_ICON_WIRED</span> %s" "$interface"
}

format_wireless() {
    local interface=$1
    local ssid=$2
    local quality=$3
    local icon=""

    if [ $quality -le 20 ]; then
        icon="$NETWORK_ICON_WIRELESS_VERY_LOW"
    elif [ "$quality" -le "40" ]; then
        icon="$NETWORK_ICON_WIRELESS_LOW"
    elif [ $quality -le 60 ]; then
        icon="$NETWORK_ICON_WIRELESS_MEDIUM"
    elif [ $quality -le 80 ]; then
        icon="$NETWORK_ICON_WIRELESS_HIGH"
    elif [ $quality -le 100 ]; then
        icon="$NETWORK_ICON_WIRELESS_VERY_HIGH"
    fi

    printf "<span foreground='$NETWORK_ICON_COLOR'>$icon</span> %s %-3s" "$ssid" "$quality%"
}

format_none() {
    printf "<span foreground='$NETWORK_ICON_COLOR'>$NETWORK_ICON_NONE</span>"
}

panel_network() {
    local interface=$(ip route | awk '/default/ { print $5 }')
    if [ -n "$interface" ]; then
        if [ -d "/sys/class/net/$interface/wireless" ]; then
            local essid=$(/sbin/iwgetid --raw)
            local quality=$(awk 'NR==3 {printf("%.0f\n",$3*10/7)}' /proc/net/wireless)
            echo "$(format_wireless "$interface" "$essid" "$quality")"
        else
            echo "$(format_wired "$interface")"
        fi
    else
        echo "$(format_none)"
    fi
}

echo $(panel_network)
