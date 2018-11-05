#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

lan_interface=$(ip link show | awk -F ':' '{print $2}' | grep 'en' | xargs)
wlan_interace=$(ip link show | awk -F ':' '{print $2}' | grep 'wl' | xargs)

# Launch polybar named example
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m LAN_INTERFACE=$lan_interface WLAN_INTERFACE=$wlan_interace polybar --reload $1 &
  done
else
  polybar --reload example &
fi

echo "Bars launched..."
