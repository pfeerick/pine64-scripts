#!/bin/bash

BATT_PRESENT=$(</sys/class/power_supply/battery/present)

if [ "$BATT_PRESENT" = "1" ]; then
	BATT_STATUS=$(</sys/class/power_supply/battery/status)

if ! which bc > /dev/null; then
	BATT_VOLTAGE=$(</sys/class/power_supply/battery/voltage_now)
	BATT_VOLTAGE=$(echo " (($BATT_VOLTAGE/10000)*0.01 ) "|bc)
else
        BATT_VOLTAGE=$(awk '{printf ("%0.2f",$1/1000000); }' </sys/class/power_supply/battery/voltage_now)
fi

	BATT_CURRENT=$(</sys/class/power_supply/battery/current_now)
	((BATT_CURRENT = BATT_CURRENT / 1000))
	BATT_CAPACITY=$(</sys/class/power_supply/battery/capacity)
	BATT_HEALTH=$(</sys/class/power_supply/battery/health)

	echo "Pine64 reports battery detected!"
	echo "Status:" $BATT_STATUS
	echo "Voltage:" $BATT_VOLTAGE"v"
	echo "Current:" $BATT_CURRENT"ma"
	echo "Capacity:" $BATT_CAPACITY"%"
	echo "Health:" $BATT_HEALTH
else
	echo "Pine64 reports battery not detected!"
fi

