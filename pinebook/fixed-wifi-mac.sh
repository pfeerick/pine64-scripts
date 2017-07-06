#!/bin/bash

if [ "$(id -u)" != "0" ]; then
        echo "This script must be executed as root. Exiting" >&2
        exit 1
fi

SSID=$(iwgetid -r)
NET_DEVICE=$(iwgetid | awk -F ' ' '{print $1}')
MAC=$(cat /sys/class/net/$NET_DEVICE/address)

nmcli con modify "$SSID" wifi.cloned-mac-address $MAC
