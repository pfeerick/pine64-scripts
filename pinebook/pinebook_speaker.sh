#!/bin/bash
# Easily mute or unmute pinebook speaker from the command line
# Written 2017 Peter Feerick, GPL v3 licensed

if [ "$1" == "mute" ]; then
  amixer -q -c 0 set "External Speaker" playback mute
elif [ "$1" == "unmute" ]; then
  amixer -q -c 0 set "External Speaker" playback unmute
else
  echo "Parameter '$1' not recognised!"
  echo "Valid paramters are 'mute' and 'unmute'"
fi
