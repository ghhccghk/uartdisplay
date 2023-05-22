#!/bin/sh

config="$(sensors | grep "temp1" | cut -c 16-24)"

echo $config
