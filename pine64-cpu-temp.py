#!/usr/bin/python
from __future__ import print_function

tempSource = "/sys/devices/virtual/thermal/thermal_zone0/temp"  # pine64

f = open(tempSource, "r")
cpu_temp = int(f.read())
f.close()

print("%.2f\u00b0C" % round(cpu_temp / 1000.0,2))
