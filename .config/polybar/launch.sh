#!/bin/bash

# Script to launch Polybar for Mint i3 laptop (brett-K501UX)

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Loop through monitors
for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    # Launch laptop bar with config file and --reload
    MONITOR=$m polybar --reload mainbar-i3-laptop -c ~/.config/polybar/config.ini &
done

echo "Polybar launched for laptop"
