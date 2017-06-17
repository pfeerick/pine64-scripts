#!/bin/bash

# Helper script for Pinebook mean to be used in conjunction with xbindkeys
# Written 2017 Peter Feerick, GPLv3 licensed.
#
# Documentation for this script on GitHub
# https://github.com/pfeerick/pine64-scripts/wiki/Pinebook-LCD-Brightness-script

# Check if required access permissions are available...
if [ ! -r "/sys/class/backlight/lcd0/actual_brightness" ] || [ ! -r "/sys/class/backlight/lcd0/max_brightness" ] || [ ! -w "/sys/class/backlight/lcd0/brightness" ]; then
  echo "This script doesn't have the necessary permissions to read or change the LCD brightness!"
  echo "Changes to permisisons or running as a root user is required."
  exit 1
fi

MINIMUM_BRIGHTNESS=5
MAXIMUM_BRIGHTNESS=$(</sys/class/backlight/lcd0/max_brightness)
ACTUAL_BRIGHTNESS=$(</sys/class/backlight/lcd0/actual_brightness)

while getopts ":i:d:s:v" opt; do
  case $opt in
    i)
      NEW_BRIGHTNESS=$((ACTUAL_BRIGHTNESS + $OPTARG))
      echo "Increase the LCD backlight brightness by $OPTARG to $NEW_BRIGHTNESS"
      ;;
    d)
      NEW_BRIGHTNESS=$((ACTUAL_BRIGHTNESS - $OPTARG))
      echo "Decrease the LCD backlight brightness by $OPTARG to $NEW_BRIGHTNESS"
      ;;
    s)
      NEW_BRIGHTNESS=$OPTARG
      echo "Set the lcd backlight brightness to $OPTARG" >&2
      ;;
    v)
      echo "Minimum brightness: $MINIMUM_BRIGHTNESS, Maximum: $MAXIMUM_BRIGHTNESS"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

#no arguments, display current value only
if [ $# -eq 0 ]; then
    echo "Current backlight brightness: $ACTUAL_BRIGHTNESS"
    exit 0
fi

#if we've gotten this far, sanity check setting and apply
if [ ! -z $NEW_BRIGHTNESS ]; then
  if [[ $NEW_BRIGHTNESS != ?(-)+([0-9]) ]]; then
    echo "Integer input expected. '$NEW_BRIGHTNESS' is NOT an integer!"
    exit 1
  fi

  if [ $NEW_BRIGHTNESS -lt $MINIMUM_BRIGHTNESS ]; then
     echo "Below mimimum brightness threshold"
     exit 1
  fi

  if [ $NEW_BRIGHTNESS -gt  $MAXIMUM_BRIGHTNESS ]; then
    echo "Above maximum brightness threshold"
    exit 1
  fi

  echo  $NEW_BRIGHTNESS > /sys/class/backlight/lcd0/brightness
fi

