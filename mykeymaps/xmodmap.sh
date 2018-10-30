#!/bin/bash

#
# keyboard hotplug script
#

if [[ $(lsusb) =~ "HHKB" ]]; then # HHKB connected?
	setxkbmap -layout us # reset keyboardmap first
	xmodmap /home/motoko/.config/mykeymaps/hhkb_key_map       
else
	setxkbmap -layout us
	xmodmap /home/motoko/.config/mykeymaps/builtin_key_map
fi

