#!/bin/bash

if [ "$(id -u)" -ne "0" ]; then
	echo "This script requires root."
	exit 1
fi

HEALTH_SCRIPT_URL="https://raw.githubusercontent.com/longsleep/build-pine64-image/master/simpleimage/platform-scripts/pine64_health.sh"
TUNE_NETWORK_SCRIPT_URL="https://raw.githubusercontent.com/longsleep/build-pine64-image/master/simpleimage/platform-scripts/pine64_tune_network.sh"

#(cd /usr/local/sbin  && wget -N $HEALTH_SCRIPT_URL)
echo "Download (only newer where possible) /usr/local/sbin/pine64_health.sh"
if [[ "$(curl $HEALTH_SCRIPT_URL -# -z "/usr/local/sbin/pine64_health.sh" -o "/usr/local/sbin/pine64_health.sh" --write-out %{http_code})" == "200" ]]; then
   chmod +x "/usr/local/sbin/pine64_health.sh"
else
   echo "Already have latest!"
fi

#(cd /usr/local/sbin && wget -N $TUNE_NETWORK_SCRIPT_URL)
echo "Download latest /usr/local/sbin/pine64_tune_network.sh"
if [[ "$(curl $TUNE_NETWORK_SCRIPT_URL -# -z "/usr/local/sbin/pine64_tune_network.sh" -o "/usr/local/sbin/pine64_tune_network.sh" --write-out %{http_code})" == "200" ]]; then
   # code here to process index.html because 200 means it gets updated
   chmod +x "/usr/local/sbin/pine64_tune_network.sh"
else
   echo "Already have latest!"
fi


#curl $TUNE_NETWORK_SCRIPT_URL -z "/usr/local/sbin/pine64_tune_network.sh" -o "/usr/local/sbin/pine64_tune_network.sh" --write-out %{http_code}


