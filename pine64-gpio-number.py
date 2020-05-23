#!/usr/bin/python3

"""Converts PC13 style GPIO designators to sysfs usable values"""

import sys
import string
import re

def convert(value):
    """Does the actual conversion"""
    alp = value[1]
    idx = string.ascii_uppercase.index(alp)
    num = int(value[2:], 10)
    res = idx * 32 + num
    return res

if __name__ == "__main__":
    ARGS = sys.argv[1:]
    if not ARGS:
        print("Usage: %s <pin>" % sys.argv[0])
        sys.exit(1)

    if not re.match(r'[P][B,C,H,L]{1}[0-9]{1,2}$', ARGS[0].upper()):
        print("Input: '%s' not a valid GPIO pin reference!" % ARGS[0])
        print()
        print("It should look something like PC13, where")
        print("   P=Pin")
        print("   C=3rd bank of GPIO connections")
        print("   13=GPIO in that specific bank")
        sys.exit(1)

    print("%d" % convert(ARGS[0].upper()))
