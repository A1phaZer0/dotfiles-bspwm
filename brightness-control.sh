#!/bin/bash

# original brightness is 120000
echo 60000 | sudo tee /sys/class/backlight/intel_backlight/brightness

