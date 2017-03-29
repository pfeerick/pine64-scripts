#!/usr/bin/python
degree_sign = u'\N{DEGREE SIGN}'.encode("utf-8")
#tempSource = "/sys/devices/platform/sunxi-i2c.0/i2c-0/0-0034/temp1_input"  # cubietruck
tempSource = "/sys/devices/virtual/thermal/thermal_zone0/temp"  # pine64

f = open(tempSource, "r") 
cpu_temp = int(f.read())
f.close()

print str(cpu_temp) + degree_sign + 'C'

