#!/bin/bash
#echo -e "Working directory: $PWD\n"
tar -czOb 1 -C $PWD "$@" | base64 -w 0 | fold -w 77

