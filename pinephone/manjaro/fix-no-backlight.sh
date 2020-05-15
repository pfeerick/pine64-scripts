#!/bin/bash

if [ "$(id -u)" != "0" ]; then
	echo -ne "This script must be executed as root. Exiting\n" >&2
	exit 1
fi

# value below 3 results in no backlight
echo 3 > /sys/class/backlight/backlight/brightness
