#!/bin/bash
# Script to launch Polybar for Mint i3 (laptop or desktop)

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Determine machine type (laptop or desktop)
if [[ "$(cat /sys/class/dmi/id/chassis_type)" =~ ^(8|9|10|11|14)$ ]]; then
    # Laptop (chassis types: 8=Portable, 9=Laptop, 10=Notebook, 11=Sub-Notebook, 14=Sub-Notebook)
    CONFIG="~/.config/polybar/laptop-config.ini"
    BAR="mainbar-i3-laptop"
else
    # Desktop
    CONFIG="~/.config/polybar/desktop-config.ini"
    BAR="mainbar-i3-desktop"
fi

# Loop through monitors
for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload $BAR -c $CONFIG &
done

echo "Polybar launched with $CONFIG"
