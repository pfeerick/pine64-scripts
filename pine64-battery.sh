#!/bin/bash

if [ -e "/sys/class/power_supply/battery" ]; then
	BATT_PATH="/sys/class/power_supply/battery"
else
	BATT_PATH="/sys/class/power_supply/axp20x-battery"
fi

BATT_PRESENT=$(<${BATT_PATH}/present)

if [ "$BATT_PRESENT" = "1" ]; then
	BATT_STATUS=$(<${BATT_PATH}/status)

if ! which bc > /dev/null; then
		BATT_VOLTAGE=$(<${BATT_PATH}/voltage_now)
		BATT_VOLTAGE=$(echo " (($BATT_VOLTAGE/10000)*0.01 ) "|bc)
	else
	        BATT_VOLTAGE=$(awk '{printf ("%0.2f",$1/1000000); }' <${BATT_PATH}/voltage_now)
	fi

	BATT_CURRENT=$(<${BATT_PATH}/current_now)
	((BATT_CURRENT = BATT_CURRENT / 1000))
	BATT_CAPACITY=$(<${BATT_PATH}/capacity)
	BATT_HEALTH=$(<${BATT_PATH}/health)

	echo "Pine64 reports battery detected!"
	echo "Status:" $BATT_STATUS
	echo "Voltage:" $BATT_VOLTAGE"v"
	echo "Current:" $BATT_CURRENT"ma"
	echo "Capacity:" $BATT_CAPACITY"%"
	echo "Health:" $BATT_HEALTH
else
	echo "Pine64 reports battery not detected!"
fi
