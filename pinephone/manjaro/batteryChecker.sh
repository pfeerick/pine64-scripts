#!/bin/bash

#get device model
if [ -f /proc/device-tree/model ]; then
	IFS= read -r -d '' DEVICE_MODEL </proc/device-tree/model || [[ $DEVICE_MODEL ]]
else
	DEVICE_MODEL="Unknown model"
fi

#paths
BATT_PATH="/sys/class/power_supply/axp20x-battery"
LED_PATH="/sys/class/leds"

RED_LED="${LED_PATH}/pinephone:red:user/brightness"
GREEN_LED="${LED_PATH}/pinephone:green:user/brightness"
BLUE_LED="${LED_PATH}/pinephone:blue:user/brightness"

#variables
LED_ONTIME=0.2
LED_OFFTIME=1.8
MODE=1

#exit nicely if Ctrl-C pressed, SIGTERM, etc sent
trap Cleanup SIGHUP SIGINT SIGTERM

Cleanup() {
	AllOff
	exit 0
} # Cleanup

Main() {
	ParseOptions "$@"

	case ${MODE} in
		1)	# oneshot battery info display
			CheckBattery
			DisplayBatteryStatus
			exit 0
			;;
		2)	# interval battery info display
			while true; do
				CheckBattery
				DisplayBatteryStatus
				sleep ${WAIT_TIME}
			done
			exit 0
			;;
		3)	# interval RGB led update
			CheckIfWritable
			while true ; do
				CheckBattery
				LedBatteryStatus
				sleep ${LED_ONTIME}
				AllOff
				sleep ${LED_OFFTIME}
			done
			exit 0
			;;
	esac

	exit 1
} # Main

CheckIfWritable() {
	if [ ! -w ${RED_LED} ]; then
		echo -ne "This script doesn't have permission to alter the LED state!\n" 1>&2
		echo -ne "Either run this script via sudo, or alter the write permissions for\n" 1>&2
		echo -ne "* ${RED_LED}\n" 1>&2
		echo -ne "* ${GREEN_LED}\n" 1>&2
		echo -ne "* ${BLUE_LED}\n" 1>&2
		exit 1
	fi
} # CheckIfWritable

ParseOptions() {
	while getopts ':hHw:dl:u:' opt ; do
	case ${opt} in
		h|H)
			DisplayUsage
			exit 0
			;;
		w)
			MODE=2
			WAIT_TIME=${OPTARG}
			;;
		l)
			LED_ONTIME=${OPTARG}
			;;
		u)
			LED_OFFTIME=${OPTARG}
			;;
		d)
			MODE=3
			;;
		\?)
			echo "Invalid option: ${OPTARG}" 1>&2
			exit 1
			;;
		:)
			echo "Invalid option: ${OPTARG} requires an argument." 1>&2
			exit 1
			;;
		esac
		done
	shift $((OPTIND -1))
} # ParseOptions

DisplayUsage() {
	echo -ne "Usage: ${0##*/} [-h] [-w interval] [-d] [-l interval] [-u interval]\n"
	echo -ne "############################################################################\n"
	echo -ne "Use batteryChecker for the following tasks:\n"
	echo -ne "  -w provides battery information every specified interval (seconds)\n"
	echo -ne "  -d provides a simple battery status led notifier\n"
	echo -ne "  -l sets a custom 'lit' led time (in seconds, default: ${LED_ONTIME})\n"
	echo -ne "  -u sets a custom 'unlit' led time (in seconds, default: ${LED_OFFTIME})\n"
	echo -ne "  -h displays this help screen\n"
	echo -ne "############################################################################\n"
} # DisplayUsage


AllOff() {
	if [ -w ${RED_LED} ]; then
		echo 0 > ${RED_LED}
	fi
	if [ -w ${GREEN_LED} ]; then
		echo 0 > ${GREEN_LED}
	fi
	if [ -w ${BLUE_LED} ]; then
		echo 0 > ${BLUE_LED}
	fi
} # AllOff

CheckBattery() {
	BATT_PRESENT=$(<${BATT_PATH}/present)

	if [ "$BATT_PRESENT" = "1" ]; then
		BATT_STATUS=$(<${BATT_PATH}/status)

		if command -v "bc" >/dev/null 2>&1 ; then
			BATT_VOLTAGE=$(<${BATT_PATH}/voltage_now)
			BATT_VOLTAGE=$(echo " (($BATT_VOLTAGE/10000)*0.01 ) "|bc)
		else
			BATT_VOLTAGE=$(awk '{printf ("%0.2f",$1/1000000); }' <${BATT_PATH}/voltage_now)
		fi

		BATT_CURRENT=$(<${BATT_PATH}/current_now)
		((BATT_CURRENT = BATT_CURRENT / 1000))
		BATT_CAPACITY=$(<${BATT_PATH}/capacity)
		BATT_HEALTH=$(<${BATT_PATH}/health)
	fi
} # CheckBattery

LedBatteryStatus() {
	if [ "$BATT_PRESENT" = "1" ]; then
		if [ "${BATT_CAPACITY}" -gt 66 ]; then
			echo 0 > $RED_LED
			echo 1 > $GREEN_LED
			echo 0 > $BLUE_LED
		elif [ "${BATT_CAPACITY}" -gt 33 ]; then
			echo 1 > $RED_LED
			echo 1 > $GREEN_LED
			echo 0 > $BLUE_LED
		else
			echo 1 > $RED_LED
			echo 0 > $GREEN_LED
			echo 0 > $BLUE_LED
		fi
	fi
} # LedBatteryStatus

DisplayBatteryStatus() {
	if [ "$BATT_PRESENT" = "1" ]; then
		echo "${DEVICE_MODEL} battery detected!"
		echo "Status: ${BATT_STATUS}"
		echo "Voltage: ${BATT_VOLTAGE}v"
		echo "Current: ${BATT_CURRENT}ma"
		echo "Capacity: ${BATT_CAPACITY}%"
		echo "Health: ${BATT_HEALTH}"
	else
		echo "${DEVICE_MODEL} battery not detected!"
	fi
} # DisplayBatteryStatus

#InstallSystemdUnit() {
#/etc/systemd/system/
#/usr/lib/systemd/system/
#} # InstallSystemdUnit

Main "$@"
