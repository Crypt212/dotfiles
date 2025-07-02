#!/bin/bash

battery_path="/sys/class/power_supply/BAT0"
ac_path="/sys/class/power_supply/ADP0"
sound_file="./notification.mp3"

[ ! -d "$battery_path" ] && exit

status=$(cat "$battery_path/status")
capacity=$(cat "$battery_path/capacity")
ac_online=$(cat "$ac_path/online")

# State file to track previous status
state_file="/tmp/battery-notify-state"

# Read previous state
prev_state=""
[ -f "$state_file" ] && prev_state=$(cat "$state_file")

# Set necessary environment variables
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus
export DISPLAY=:0

play_sound() {
    [ -f "$sound_file" ] && paplay "$sound_file"
}

play_sound

# Handle notifications
notify() {
    case "$1" in
        plugged)
            notify-send -u normal -t 5000 "Power Connected" "Battery is now charging ($capacity%)"
            ;;
        unplugged)
            # notify-send -u normal -t 5000 "Power Disconnected" "Running on battery ($capacity%)" # this should be normal way
            notify-send -u critical -t 5000 "Power Disconnected" "Running on battery ($capacity%)" # but this for my shitty laptop
            ;;
        low)
            notify-send -u critical -t 10000 "LOW BATTERY" "Only $capacity% remaining - Plug in charger!"
            ;;
        critical)
            notify-send -u critical -t 0 "CRITICAL BATTERY" "Only $capacity% remaining - System will suspend soon!"
            ;;
    esac
}

# Check for AC state change
if [ "$ac_online" != "$prev_state" ]; then
    play_sound
    if [ "$ac_online" -eq 1 ]; then
        notify plugged
    else
        notify unplugged
    fi
    echo "$ac_online" > "$state_file"
fi

# Check battery level when discharging
if [ "$status" = "Discharging" ]; then
    play_sound
    if [ "$capacity" -le 10 ]; then
        notify critical
    elif [ "$capacity" -le 20 ]; then
        notify low
    fi
fi

# Output for Waybar (optional)
echo "{}"
