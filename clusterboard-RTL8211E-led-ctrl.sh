#!/bin/bash

# Thanks to joncostello from the pine64 for the inspiration for writing this
# https://forum.pine64.org/showthread.php?tid=9780

MODE="none"
QUIET=0

LedsOff() {
	# set to extension page, extension Page44
	phytool write eth0/0/31 0x0007
	phytool write eth0/0/30 0x2c
	# link rx/tx steady mode, no link up indicator
	phytool write eth0/0/0x1a 0x0000
	phytool write eth0/0/0x1c 0x0000
	# switch to the PHY’s Page
	phytool write eth0/0/31 0x0000
} # LedsOff

LedsOn() {
	# set to extension page, extension Page44
	phytool write eth0/0/31 0x0007
	phytool write eth0/0/30 0x2c
	# link rx/tx blinking mode, re-enable link up indicator
	phytool write eth0/0/0x1a 0x00d1
	phytool write eth0/0/0x1c 0x9770
	# switch to the PHY’s Page
	phytool write eth0/0/31 0x0000
} # LedsOn

Main() {
	ParseOptions "$@"

	if [ $# -eq 0 ] || [ ${MODE} == "none" ]; then
		DisplayUsage
		exit 1
	fi

	CheckRootPriv
	CheckDependencies

	case "${MODE}" in
		enable_leds)
			if [ $QUIET != 1 ]; then echo "Disabling NIC Leds..."; fi
			LedsOff
			exit 0
			;;
		disable_leds)
			if [ $QUIET != 1 ]; then echo "Enabling NIC Leds..."; fi
			LedsOn
			exit 0
			;;
		show_regs)
			LACR=$(phytool read eth0/0/0x1a)
			LCR=$(phytool read eth0/0/0x1c)

			echo "LED Action Control Register (LACR) = ${LACR}"
			echo "LED Control Register (LCR)         = ${LCR}"
			exit 0
			;;
	esac

	exit 1
} # Main

ParseOptions() {
	while getopts ':hHedsq' opt ; do
		case ${opt} in
			h|H)
				DisplayUsage
				exit 0
				;;
			e)
				MODE="enable_leds"
				;;
			d)
				MODE="disable_leds"
				;;
			s)
				MODE="show_regs"
				;;
			q)
				QUIET=1
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
	echo "Usage: ${0##*/} [-h] [-e] [-d] [-s] [-q]"
	echo "############################################################################"
	echo "Use clusterboard-RTL8211E-led-ctrl for the following tasks:"
	echo "  -e enables the RTL8211E (ethernet transceiver) leds"
	echo "  -d disables the RTL8211E (ethernet transceiver) leds"
	echo "  -s shows the current RTL8211E LACR/LCR register values"
	echo "  -q hides output from enable/disable commands"
	echo "  -h displays this help screen"
	echo "############################################################################"
} # DisplayUsage

CheckRootPriv() {
	if [ "$(id -u)" != "0" ]; then
		echo -ne "This script must be executed as root. Exiting\n" >&2
		exit 1
	fi
} # CheckRootPriv

CheckDependencies() {
 	command -v phytool >/dev/null 2>&1 || { echo >&2 "phytool (https://github.com/wkz/phytool) is required but not detected. Aborting."; exit 1; }
} # CheckDependencies

Main "$@"
