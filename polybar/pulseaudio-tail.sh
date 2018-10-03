#!/bin/bash
# original https://github.com/x70b1/polybar-scripts/tree/master/polybar-scripts/pulseaudio-tail
# modified by A1phaZer0 @ github

set_icons() {
    if pacmd list-sinks | grep active | head -n 1 | grep -q speaker; then
	icons=("" "" "" "" ); 
    elif pacmd list-sinks | grep active | head -n 1 | grep -q headphones; then
	icons=("" "" "" "" );
    else
	icons=("N/A" "N/A" "N/A" "N/A" );
    fi
}

sink=0

volume_up() {
    pactl set-sink-volume $sink +1%
}

volume_down() {
    pactl set-sink-volume $sink -1%
}

volume_mute() {
    pactl set-sink-mute $sink toggle
}

volume_print() {

    set_icons

    muted=$(pamixer --sink $sink --get-mute)

    if [[ "$muted" == true ]]; then
	icon=${icons[0]};
        echo "%{F#F95738}$icon --%{F-}"
    else
	vol=$(pamixer --sink $sink --get-volume)
	
	if [[ $vol -gt 70 ]]; then
	    icon=${icons[3]};
            echo "%{F#F95738}$icon $(pamixer --sink $sink --get-volume)%%{F-}"
	elif [[ $vol -gt 35 ]]; then
	    icon=${icons[2]};
	    echo "%{F#F95738}$icon $(pamixer --sink $sink --get-volume)%%{F-}"
	else
	    icon=${icons[1]};
	    echo "%{F#F95738}$icon $(pamixer --sink $sink --get-volume)%%{F-}"
        fi

    fi
}

listen() {
    volume_print

    pactl subscribe | while read -r event; do
        if echo "$event" | grep -q "#$sink"; then
            volume_print
        fi
    done
}

case "$1" in
    --up)
        volume_up
        ;;
    --down)
        volume_down
        ;;
    --mute)
        volume_mute
        ;;
    *)
        listen
        ;;
esac
