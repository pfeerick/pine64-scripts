#!/usr/bin/python
from __future__ import print_function

TEMP_SOURCE = "/sys/devices/virtual/thermal/thermal_zone0/temp"  # pine64

F = open(TEMP_SOURCE, "r")
CPU_TEMP = int(F.read())
F.close()

print("{:.2f}\u00b0C".format(CPU_TEMP/1000.0))
