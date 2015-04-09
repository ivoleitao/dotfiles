#!/bin/bash

source "/home/ivoleitao/bin/kv-shell.sh"
source "$(dirname $0)/config.sh"

format_bandwidth() {
    local download_rate=$1
    local upload_rate=$2

    local download_icon="$BANDWIDTH_ICON_DOWNLOAD"
    local upload_icon="$BANDWIDTH_ICON_UPLOAD"
    local download_icon_color="$BANDWIDTH_ICON_DOWNLOAD_COLOR"
    local upload_icon_color="$BANDWIDTH_ICON_UPLOAD_COLOR"
    local download_value=""
    local upload_value=""

    # shift by 10 bytes to get KiB/s. If the value is larger than
    # 1024^2 = 1048576, then display MiB/s instead
    # Download
    local rx_kib=$(( $download_rate >> 10 ))
    if [[ "$download_rate" -gt 1048576 ]]; then
        download_value=$(echo "scale=1; $rx_kib / 1024" | bc)
        download_value="${download_value}M"
    else
        download_value="${rx_kib}K"
    fi

    # Upload
    local tx_kib=$(( $upload_rate >> 10 ))
    if [[ "$upload_rate" -gt 1048576 ]]; then
        upload_value=$(echo "scale=1; $tx_kib / 1024" | bc)
        upload_value="${upload_value}M"
    else
        upload_value="${tx_kib}K"
    fi

    printf "<span foreground='$download_icon_color'>$download_icon</span> %5s <span foreground='$upload_icon_color'>$upload_icon</span> %5s" "$download_value" "$upload_value"
}

panel_bandwidth() {
    local data_key="panel_bandwidth_data"
    local interface=""
    # Use the provided interface, otherwise the device used for the default route.
    if [[ -n $BANDWIDTH_INTERFACE ]]; then
        interface=$BANDWIDTH_INTERFACE
    else
        interface=$(ip route | awk '/^default/ { print $5 ; exit }')
    fi

    local rx_rate="0"
    local tx_rate="0"
    if [ -e "/sys/class/net/${interface}/operstate" ] && [ "`cat /sys/class/net/${interface}/operstate`" = "up" ]; then
        # get time in miliseconds
        local time=$(date +%s)
        # grabbing data for each adapter.
        read rx < "/sys/class/net/${interface}/statistics/rx_bytes"
        read tx < "/sys/class/net/${interface}/statistics/tx_bytes"
        local data="${time} ${rx} ${tx}"

        # read previous state and update data storage
        local old_data=$(kvget $data_key)
        if [[ ! -n $old_data ]]; then
            old_data="$data"
        fi
        kvset $data_key "$data" 

        # parse old data and calc time passed
        local test_val=$old_data
        old_data=(${old_data//;/ })
        local time_diff=$(( $time - ${old_data[0]} ))

        # sanity check: has a positive amount of time passed
        [[ "${time_diff}" -gt 0 ]] || exit

        # calc bytes transferred, and their rate in byte/s
        local rx_diff=$(( $rx - ${old_data[1]} ))
        local tx_diff=$(( $tx - ${old_data[2]} ))
        rx_rate=$(( $rx_diff / $time_diff ))
        tx_rate=$(( $tx_diff / $time_diff ))
    fi
   
    echo "$(format_bandwidth "$rx_rate" "$tx_rate")"
}

echo $(panel_bandwidth)
