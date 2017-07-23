#!/bin/bash

Main() {
	RootCheck
	[ -f cpuburn ] || PrepareCpuBurn

	./cpuburn &
	PROC_ID=$!

	trap Finish 2

	while kill -0 "$PROC_ID" >/dev/null 2>&1; do
		MonitorMode
	done
}

Finish() {
	echo -e "\n'Ctrl+C' detected. Killing any cpuburn processes..."
	kill -9 $(pidof cpuburn)
	exit 0
}

RootCheck() {
	if [ "$(id -u)" != "0" ]; then
		echo "${0##*/} requires root privleges - run as root or through sudo. Exiting" >&2
		exit 1
	fi
}

PrepareCpuBurn() {
	echo "Downloading and compiling cpuburn-a53 ... "
	curl -LO https://raw.githubusercontent.com/ssvb/cpuburn-arm/master/cpuburn-a53.S
	gcc -o cpuburn cpuburn-a53.S
}

#display stats - ripped from armbianmonitor monitor mode
MonitorMode() {
	DisplayHeader="Time        CPUInfo    Scaling"
	CPUs=normal
	[ -f /sys/devices/virtual/thermal/thermal_zone0/temp ] && DisplayHeader="${DisplayHeader}   CPU" || SocTemp='n/a'
	echo -e "${DisplayHeader}\c"
	Counter=0
	while true ; do
		let Counter++
		if [ ${Counter} -eq 15 ]; then
			echo -e "\n${DisplayHeader}\c"
			Counter=0
		fi

		CpuinfoCpuFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq) 2>/dev/null
		ScalingCpuFreq=$(awk '{printf ("%0.0f",$1/1000); }' </sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq) 2>/dev/null

		echo -e "\n$(date "+%H:%M:%S"): $(printf "%4s" ${CpuinfoCpuFreq})MHz \t$(printf "%4s"MHz ${ScalingCpuFreq}) \c"
		if [ "X${SocTemp}" != "Xn/a" ]; then
			read SocTemp </sys/devices/virtual/thermal/thermal_zone0/temp
			if [ ${SocTemp} -ge 1000 ]; then
				SocTemp=$(awk '{printf ("%0.1f",$1/1000); }' <<<${SocTemp})
			fi
			echo -e " $(printf "%4s" ${SocTemp})°C\c"
		fi
		sleep ${1:-2}
	done
}

Main "$@"

