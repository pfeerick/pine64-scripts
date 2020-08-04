#!/usr/bin/env python

# license:     GPLv3

# Import the necessary header modules
from time import sleep
import sys, signal, argparse, datetime

import RPi.GPIO as GPIO

degreeSymbol = u'\u00b0'.encode('utf8')
#degreeC = u'\u2103'.encode('utf8')

delay = 10              # seconds of delay, testing the cpu temp every minute i
cool_upper_limit = 47      # start cooling from this temp in Celcius
cool_lower_limit = 38
fanRunning = False
fan_pin = 23            # GPIO 23, pin 16 for fan power control

def signal_handler(signal, frame):
        print('You pressed Ctrl+C!')
        GPIO.output(fan_pin, GPIO.LOW)
        GPIO.cleanup()  # clean up GPIO on CTRL+C exit()
        sys.exit(0)


def main():
    global fan_pin
    global delay
    global cool_baseline
    global cool_hysterisis
    global cool_lower_limit
    global cool_upper_limit

    parser = argparse.ArgumentParser(description='Temperature control cooling fan connected to a GPIO pin.')

    parser.add_argument("-v", "--verbose", help="increase output verbosity", action="store_true")
    parser.add_argument("-p", "--fanPin", type=int, help="set the GPIO pin the fan is connected to")
    parser.add_argument("-d", "--delay", type=int, help="set the delay between temperature checks")
    parser.add_argument("-u", "--upperLimit", type=int, help="set the temperature the cooling fan comes on at")
    parser.add_argument("-l", "--lowerLimit", type=int, help="how much lower than the trigger temperature should the fan cool before stopping")

    args = parser.parse_args()

    if args.fanPin:
        # print "setting custom fan pin", args.fanPin
        fan_pin = args.fanPin

    if args.delay:
        delay = args.delay

    if args.upperLimit:
        cool_upper_limit = args.upperLimit

    if args.lowerLimit:
        cool_lower_limit = args.lowerLimit

    if args.verbose:
        print "Fan pin:",fan_pin
        print "Delay:",delay
        print "Upper (trigger) temperature:", str(cool_upper_limit) + degreeSymbol + "C"
        print "Lower (end) temperature:", str(cool_lower_limit) + degreeSymbol + "C"


    GPIO.setmode(GPIO.BCM)   # choose BCM numbering scheme
    GPIO.setwarnings(False)  # when everything is working you can turn warnings off
    GPIO.setup(fan_pin, GPIO.OUT)  # set GPIO port for the fan control pin

    fanRunning = False
    signal.signal(signal.SIGINT, signal_handler)

    # loop
    while True:
        # get the cpu temperature
        with open("/sys/devices/virtual/thermal/thermal_zone0/temp", "r") \
        as fin:
            f_data = fin.readline()
            cpu_temp = int(f_data[0:2])  # for Celcius : temp=43.9'C

        if args.verbose: print '{:%H:%M:%S}'.format(datetime.datetime.now()), "Temperature:", str(cpu_temp) + degreeSymbol + "C"  # for debugging

        if cpu_temp <= cool_lower_limit:
            if fanRunning:
                if args.verbose: print '{:%H:%M:%S}'.format(datetime.datetime.now()), "Cooling threshold of", str(cool_lower_limit) + degreeSymbol + "C", "reached, switching fan off"
                GPIO.output(fan_pin, GPIO.LOW)
                fanRunning = False
            else:
                pass
        elif cpu_temp >= cool_upper_limit:
            if not fanRunning:
                if args.verbose: print '{:%H:%M:%S}'.format(datetime.datetime.now()), "Upper threshold of", str(cool_upper_limit) + degreeSymbol + "C", "reached, switching fan on"
                GPIO.output(fan_pin,GPIO.HIGH)
                fanRunning = True
            else:
                pass
        else:
#            print "do nothing"
#	    if fanRunning = true:
#                GPIO.output(fan_pin,GPIO.HIGH)
#	    else:
#                GPIO.output(fan_pin,GPIO.LOW)

            pass

#        print "sleep"  # for debugging
        sleep(delay)

if __name__ == "__main__":
   main()

