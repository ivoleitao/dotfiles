#!/bin/bash

source "$(dirname $0)/config.sh"

format_wired() {
    local ip=$1
    printf "<span foreground='$NETWORK_ICON_COLOR'>$NETWORK_ICON_WIRED</span> %s" "$ip"
}

format_wireless() {
    local ip=$1
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

    printf "<span foreground='$NETWORK_ICON_COLOR'>$icon</span> (%-3s at %s) %s" "$quality%" "$ssid" "$ip"
}

format_none() {
    printf "<span foreground='$NETWORK_ICON_COLOR'>$NETWORK_ICON_NONE</span>"
}

panel_network() {
    local net=$(ip addr)
    local eth_state=$(echo "$net" | awk '/'$NETWORK_INTERFACE_WIRED':/  { print $9 }')
    local wlan_state=$(echo "$net" | awk '/'$NETWORK_INTERFACE_WIRELESS':/ { print $9 }')
    local interface=""
    if [[ "$eth_state" == "UP" && "$wlan_state" == "UP" ]]; then
        interface=$(ip route | awk '/default/ { print $5 }')
    elif [ "$eth_state" == "UP" ]; then
        interface=$NETWORK_INTERFACE_WIRED
    elif [ "$wlan_state" == "UP" ]; then
        interface=$NETWORK_INTERFACE_WIRELESS
    fi
    
    local ip=""
    if [[ "$interface" == "$NETWORK_INTERFACE_WIRED" ]]; then
        ip=$(echo "$net" | awk '/inet.*'$NETWORK_INTERFACE_WIRED'/  { print $2 }')
        echo "$(format_wiredi "$ip")"
    elif [ "$interface" == "$NETWORK_INTERFACE_WIRELESS" ]; then
        ip=$(echo "$net" | awk '/inet.*'$NETWORK_INTERFACE_WIRELESS'/  { print $2 }')
        local essid=$(/sbin/iwgetid --raw)
        local quality=$(awk 'NR==3 {printf("%.0f\n",$3*10/7)}' /proc/net/wireless)
        echo "$(format_wireless "$ip" "$essid" "$quality")"
    else
        echo "$(format_none)"
    fi
}

echo $(panel_network)
