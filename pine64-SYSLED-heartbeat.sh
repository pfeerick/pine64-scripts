#!/bin/bash

function openGPIO
{
        #test if GPIO sysfs entry exists, create if necessary
        if [ ! -e "/sys/class/gpio/gpio359" ]; then
#               echo "DEBUG: export 359"
                echo 359 > "/sys/class/gpio/export"
		sleep 0.1
        fi

        #test direction is set correctly, set if necessary
        GPIO_359_DIRECTION=$(</sys/class/gpio/gpio359/direction)

        if [ "$GPIO_359_DIRECTION" != "out" ]; then
#               echo "DEBUG: direction out"
                echo out > /sys/class/gpio/gpio359/direction
		sleep 0.1
        fi
}

function closeGPIO
{
        #turn off, unexport GPIO sysfs entry, and quit nicely
        echo 1 > "/sys/class/gpio/gpio359/value"
        echo 359 > "/sys/class/gpio/unexport"
}

function cleanup
{
        closeGPIO
        exit 0
}


#unexport and exit nicely if Ctrl-C pressed, SIGTERM, etc sent
trap cleanup SIGHUP SIGINT SIGTERM

openGPIO

#absorb likely error from first access to GPIO value
echo 0 | tee "/sys/class/gpio/gpio359/value" > /dev/null 2>&1

#momentary pause to let udev do its magic
sleep 0.1

#main loop
while true
do
        echo 0 > "/sys/class/gpio/gpio359/value" #on
        sleep 0.1s
        echo 1 > "/sys/class/gpio/gpio359/value" #off
        sleep 0.1s
        echo 0 > "/sys/class/gpio/gpio359/value" #on
        sleep 0.1s
        echo 1 > "/sys/class/gpio/gpio359/value" #off
        sleep 0.1s
        echo 1 > "/sys/class/gpio/gpio359/value" #off
        sleep 9.7s
done

exit 0

