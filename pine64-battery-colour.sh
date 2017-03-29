#!/bin/bash

SWITCH="\033["
NORMAL="${SWITCH}0m"
RED="${SWITCH}1;31m"
GREEN="${SWITCH}1;32m"
YELLOW="${SWITCH}1;33m"
PURPLE="${SWITCH}1;35m"
BLUE="${SWITCH}1;34m"
CYAN="${SWITCH}1;36m"

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

	echo -e "${PURPLE}Pine64${NORMAL} reports battery ${GREEN}detected!${NORMAL}"
	echo -e "${YELLOW}Status:${NORMAL}" $BATT_STATUS
	echo -e "${YELLOW}Voltage:${NORMAL}" $BATT_VOLTAGE"v"
	echo -e "${YELLOW}Current:${NORMAL}" $BATT_CURRENT"ma"
	echo -e "${YELLOW}Capacity:${NORMAL}" $BATT_CAPACITY"%"
	echo -e "${YELLOW}Health:${NORMAL}" $BATT_HEALTH
else
	echo -e "${PURPLE}Pine64${NORMAL} reports battery ${RED}not detected!${NORMAL}"
fi

