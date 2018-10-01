#!/bin/bash



# get primary monitor
PRIM_MON=$( xrandr -q | grep primary | awk '{print $1}' )

# get other monitor(s)
OTHR_MON=()

# output rules for monitors
# RULE_1="xrandr --output DP-3 --mode 1920x1080 --left-of eDP-1 --rotate right"

function reset_prim_monitor()
{
	bspc monitor $PRIM_MON -d term-1 pwn-1 web-1 vm-1 misc-1
}

function reset_other_monitors()
{
	bspc monitor $1 -d term-2 pwn-2 web-2 vm-2 misc-2
}

function delay()
{
	for i in $(seq 1 100000); do
		echo;
	done
}

function add_monitor()
{
	xrandr --output $1 --mode $2 $3 $4 $5
	bspc config -m $1 top_padding 0
	bspc config -m $1 bottom_padding 0
	bspc config -m $1 left_padding 0
	bspc config -m $1 right_padding 0
	# add new desktop if new monitor detected first time
	# or just move its desktops back
	if [[ $1 == 'DP-3' ]] ; then
		if [[ $( bspc query -m $PRIM_MON -D --names | wc -l ) -eq 5 ]] ; then
			bspc monitor $1 -d term-2 pwn-2 web-2 vm-2 misc-2
		else
			#bspc desktop %Desktop -r
			desktops=( "term-2" "pwn-2" "web-2" "vm-2" "misc-2" )
			for dt in ${desktops[@]} ; do
				bspc desktop "%"$dt -m $1
			done
			reset_prim_monitor # reset primary monitor
			bspc desktop %Desktop -r

		fi

		# reset monitor order, make sure workspaces are in
		# right order
		bspc wm --reorder-monitors $PRIM_MON $1
	fi

	delay
	feh --bg-fill '/home/motoko/Pictures/wallpapers/6.png' --bg-fill '/home/motoko/Pictures/wallpapers/cc-wallpaper-desktop.png'
}

# when monitor removed
function remove_monitor()
{

	if [[ $1 == 'DP-3' ]] ; then
		desktops=( "term-2" "pwn-2" "web-2" "vm-2" "misc-2" )
	fi
	for dt in ${desktops[@]} ; do
		bspc desktop "%"$dt -m $PRIM_MON
	done

	delay
	xrandr --output $1 --off
	#bspc monitor $1 -r
	delay
	feh --bg-fill '/home/motoko/Pictures/wallpapers/6.png' --bg-fill /home/motoko/Pictures/wallpapers/cc-wallpaper-desktop.png
}

delay
feh --bg-fill '/home/motoko/Pictures/wallpapers/6.png' --bg-fill /home/motoko/Pictures/wallpapers/cc-wallpaper-desktop.png

# set other monitors
CURR_MON=''
for mon in $( xrandr -q | grep ' connected ' | grep -v 'primary' | awk '{print $1}' ); do
	OTHR_MON+=( $mon )
	CURR_MON=$mon:$CURR_MON
done


# add new monitors
[[ -e /tmp/bspwm_monitors_connected ]] && CONN_MON=$(</tmp/bspwm_monitors_connected)
for mon in ${OTHR_MON[@]}; do
	[[ $mon == 'DP-3' ]] && [[ ! $CONN_MON =~ 'DP-3' ]] && add_monitor $mon "1920x1080" "--left-of" "eDP-1" "--rotate right"
done


# remove monitors
[[ -e /tmp/bspwm_monitors_connected ]] && IFS=: read -ra CONN_MON <<< $(</tmp/bspwm_monitors_connected)
for mon in ${CONN_MON[@]}; do 
	[[ $mon == 'DP-3' ]] && [[ ! $CURR_MON =~ 'DP-3' ]] && remove_monitor $mon
done


# reset bspwm_monitors_connected
echo $CURR_MON > /tmp/bspwm_monitors_connected



# setup bar
[[ -n $(pidof polybar) ]] && polybar-msg cmd restart
polybar top-bar &

# set primary monitor
delay
bspc config -m $PRIM_MON top_padding 32
bspc config -m $PRIM_MON bottom_padding 0
bspc config -m $PRIM_MON left_padding 0
bspc config -m $PRIM_MON right_padding 0
