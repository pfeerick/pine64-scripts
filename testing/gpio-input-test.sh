#!/bin/bash

RootCheck() {
	if [ "$(id -u)" != "0" ]; then
		echo "${0##*/} requires root privleges - run as root or through sudo. Exiting" >&2
		exit 1
	fi
}

usage() {
        echo "Usage:"
        echo "$ $0 <gpio> [-in]"
        echo ""
        echo " gpio - gpio number to test"
        echo ""
        echo " -in  - set the direction to be 'in'"
        echo ""
        exit 1
}

cleanup() {
        echo "CTRL-C pressed!"
        echo ${GPIO_NUM} > "${GPIO_PATH}/unexport"
        exit 0
}

if [[ $# -ne 1 ]] && [[ $# -ne 2 ]]; then
    usage
fi

RootCheck

#catch Ctrl+C
trap cleanup 2

GPIO_NUM="$1"
GPIO_PATH="/sys/class/gpio/"

test ! -e ${GPIO_PATH}${GPIO_NUM} && echo 73 > "/sys/class/gpio/export"

if [[ $2 == "-in" ]]; then
        echo -ne "'direction' of GPIO #${GPIO_NUM} is currently "
        cat ${GPIO_PATH}/gpio${GPIO_NUM}/direction
        echo "Setting direction to 'in'..."
        echo in > ${GPIO_PATH}/gpio${GPIO_NUM}/direction
fi

while true; do
	echo -ne "value of GPIO #${GPIO_NUM}: "
	cat ${GPIO_PATH}${GPIO_NUM}/value
	sleep 1
done
