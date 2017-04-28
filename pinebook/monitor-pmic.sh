#!/bin/bash

# Monitor script to gather PMIC temperature data for rpi-monitor
# Written 2017 pfeeick, initial code provided by tkaiser
# Licensed under GPL v3

while true ; do
        echo 1 >/sys/class/axppower/axpdebug
        dmesg | tail -n40 | awk -F" " '/charger->ic_temp/ {print $NF}' | head -n1 >/tmp/pmictemp
        sleep 15
done
