#!/bin/bash

if [ "$(id -u)" != "0" ]; then
        echo "This script must be executed as root. Exiting" >&2
        exit 1
fi

cd /tmp
wget -q https://raw.githubusercontent.com/armbian/u-boot-pine64-armbian/93722e878ece4a48cef3fe035e5b37e8d31cd84d/blobs/sun50i-a64-pine64-pinebook.dts

#install device-tree-compiler if neccessary
dpkg -l | grep -qw device-tree-compiler || apt-get install device-tree-compiler

#backup old, compile new DTS
cp -p /boot/pine64/sun50i-a64-pine64-pinebook.dtb /boot/pine64/sun50i-a64-pine64-pinebook.dtb.bak
dtc -I dts -O dtb -o /boot/pine64/sun50i-a64-pine64-pinebook.dtb sun50i-a64-pine64-pinebook.dts

echo -e "\nPlease reboot your Pinebook to allow the new PMIC settings be applied\n"
