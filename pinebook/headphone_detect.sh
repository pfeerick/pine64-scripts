#!/bin/bash
#
#  Written 2017 by Peter Feerick, GPLv3 licensed
#
#  Depends on evtest to function, run 'sudo apt install evtest'
#  on a debian based system to install if missing.

LAST_HEADPHONE_STATE=2 #invalid value to guarantee first check
LAST_MIC_STATE=2

#check headphone jack state
checkHeadphoneJackState() {
	evtest --query /dev/input/event2 EV_SW SW_HEADPHONE_INSERT
	HEADPHONE_STATE=$?
}

#check mic jack state
checkMicJackState() {
	evtest --query /dev/input/event2 EV_SW SW_MICROPHONE_INSERT
	MIC_STATE=$?
}

while true ; do

	checkHeadphoneJackState

	if [ ! $HEADPHONE_STATE -eq $LAST_HEADPHONE_STATE ]; then
		if [ $HEADPHONE_STATE -eq 10 ]; then
   			amixer -q set "External Speaker" mute
		else
   			amixer -q set "External Speaker" unmute
		fi
		LAST_HEADPHONE_STATE=$HEADPHONE_STATE
#		echo "Headphone state:" $HEADPHONE_STATE

	fi

#	checkMicJackState

#	if [ ! $MIC_STATE -eq $LAST_MIC_STATE ]; then
#		if [ $MIC_STATE -eq 10 ]; then
#		else
#		fi
#		LAST_MIC_STATE=$HEADPHONE_STATE
#		echo "Mic state:" $MIC_STATE

#	fi

	sleep 0.2
done
