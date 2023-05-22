#!/bin/sh

config="$(cut -c1-3 /sys/class/thermal/thermal_zone0/temp | awk '{print $1/10}')"
echo $config°C
