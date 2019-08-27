#!/bin/bash


# get primary monitor
PRIM_MON=$( xrandr -q | grep primary | awk '{print $1}' )

# get other monitor(s)
OTHR_MON=()

# output rules for monitors
# RULE_1="xrandr --output DP-3 --mode 1920x1080 --left-of LVDS-1 --rotate right"


function delay()
{
	for i in $(seq 1 100000); do
		echo;
	done
}

function add_monitor()
{
	# add new desktop if new monitor detected first time
	# or just move its desktops back
	if [[ $1 == 'DP-3' ]] ; then
		xrandr --output $1 --mode $2 $3 $4 $5
		desktops=( "term-1" "pwn-1" "web-1" "vm-1" "misc-1" "term-2" "pwn-2" "web-2" "vm-2" "misc-2" )
		for dt in ${desktops[@]} ; do
			bspc desktop "%"$dt -m $1 --follow
		done


		# reset monitor order, make sure workspaces are in
		# right order
	fi

	if [[ $1 == 'eDP-1' ]] ; then
		xrandr --output $1 --mode $2 
		desktops=( "term-1" "pwn-1" "web-1" "vm-1" "misc-1" "term-2" "pwn-2" "web-2" "vm-2" "misc-2" )
		for dt in ${desktops[@]} ; do
			bspc desktop "%"$dt -m $1 --follow
		done
	fi

	bspc config -m $1 top_padding 20
	bspc config -m $1 bottom_padding 0
	bspc config -m $1 left_padding 0
	bspc config -m $1 right_padding 0

	delay
	feh --bg-fill '/home/motoko/Pictures/wallpapers/wallhaven-j8oqjq.png' --bg-fill '/home/motoko/Pictures/wallpapers/wallhaven-j8oqjq.png'
}

# when monitor removed
function remove_monitor()
{
	xrandr --output $1 --off
	#bspc monitor $1 -r
	delay
	feh --bg-fill '/home/motoko/Pictures/wallpapers/wallhaven-j8oqjq.png' --bg-fill /home/motoko/Pictures/wallpapers/wallhaven-j8oqjq.png
}

delay
feh --bg-fill '/home/motoko/Pictures/wallpapers/wallhaven-j8oqjq.png' --bg-fill /home/motoko/Pictures/wallpapers/wallhaven-j8oqjq.png

# set other monitors
CURR_MON=''
for mon in $( xrandr -q | grep ' connected ' | grep -v 'primary' | awk '{print $1}' ); do
	OTHR_MON+=( $mon )
	CURR_MON=$mon:$CURR_MON
done


#
# add new monitors & remove default laptop monitor if external one is big
#
[[ -e /tmp/bspwm_monitors_connected ]] && CONN_MON=$(</tmp/bspwm_monitors_connected)
for mon in ${OTHR_MON[@]}; do
	[[ $mon == 'DP-3' ]] && [[ ! $CONN_MON =~ 'DP-3' ]] && add_monitor $mon "2560x1440" 
done

if [[ $(xrandr -q | grep ' connected ' | grep -v 'primary') =~ '2560' ]] ; then
	killall -q polybar
	remove_monitor $PRIM_MON
	export MAIN_MON=DP-3
	#[[ -n $(pidof polybar) ]] && polybar-msg cmd restart
	if [[ $(id) =~ 'root' ]] ; then
		su - motoko -c "polybar main-bar &"
	else
		polybar main-bar &
	fi
fi

#
# remove monitors
#
if [[ ! $(xrandr -q | grep ' connected ' | grep -v 'primary')  ]] ;  then
	killall -q polybar
	add_monitor $PRIM_MON 1920x1080
	export PRIM_MON
	#[[ -n $(pidof polybar) ]] && polybar-msg cmd restart
	if [[ $(id) =~ 'root' ]] ; then
		su - motoko -c "polybar top-bar &"
	else
		polybar top-bar &
	fi
fi

[[ -e /tmp/bspwm_monitors_connected ]] && IFS=: read -ra CONN_MON <<< $(</tmp/bspwm_monitors_connected)
for mon in ${CONN_MON[@]}; do 
	[[ $mon == 'DP-3' ]] && [[ ! $CURR_MON =~ 'DP-3' ]] && remove_monitor $mon
done



# reset bspwm_monitors_connected
echo $CURR_MON > /tmp/bspwm_monitors_connected

