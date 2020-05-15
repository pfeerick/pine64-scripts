#!/bin/bash

MODE="none"

Main() {
	ParseOptions "$@"

	if [ $# -eq 0 ] || [ ${MODE} == "none" ]; then
		echo "Specify a power saving mode!!!"
                echo "  -0 = disable"
                echo "  -1 = minimum power saving"
		echo "  -2 = maximum power saving"
		echo "  -s = show current setting"
		exit 1

	fi

	case "${MODE}" in 
		0) 	#0 = disable power saving
			CheckRoot
			echo 0 > /sys/module/8723cs/parameters/rtw_power_mgnt
			echo 0 > /sys/module/8723cs/parameters/rtw_ips_mode
			exit 0
			;;
		1) 	#1 = power saving on, minPS
			CheckRoot
			echo 1 > /sys/module/8723cs/parameters/rtw_power_mgnt
			echo 1 > /sys/module/8723cs/parameters/rtw_ips_mode
			exit 0
			;;
		2)	#2 = power saving on, maxPS
			CheckRoot
			echo 2 > /sys/module/8723cs/parameters/rtw_power_mgnt
			echo 1 > /sys/module/8723cs/parameters/rtw_ips_mode
			exit 0
			;;
		s)	#show current setting
			RTW_POWER_MGNT=$(</sys/module/8723cs/parameters/rtw_power_mgnt)
			RTW_IPS_MODE=$(</sys/module/8723cs/parameters/rtw_ips_mode)
			RTW_ENUSBSS=$(</sys/module/8723cs/parameters/rtw_enusbss)
			echo "Power management mode (rtw_power_mgnt) = ${RTW_POWER_MGNT}"
			echo "Inactive power save mode (rtw_ips_mode) = ${RTW_IPS_MODE}"
			echo "USB autosuspend (rtw_enusbss) = ${RTW_ENUSBSS}"
			exit 0
			;;

	esac
	exit 1
}

ParseOptions() {
	while getopts ':012s' opt ; do
		case ${opt} in
			0)
				MODE=0
				;;
			1)
				MODE=1
				;;
			2)
				MODE=2
				;;
			s)	MODE=s
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

#check for root priv
CheckRoot() {
if [ "$(id -u)" != "0" ]; then
	echo -ne "This script must be executed as root. Exiting\n" >&2
	exit 1
fi
} # CheckRoot



Main "$@"
