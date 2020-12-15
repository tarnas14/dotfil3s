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
    if [[ "$m" == *"HDMI"* ]]; then
      MONITOR=$m LAN_INTERFACE=$lan_interface WLAN_INTERFACE=$wlan_interace polybar --reload secondary &
    fi
    if [[ "$m" == *"eDP"* ]]; then
      MONITOR=$m LAN_INTERFACE=$lan_interface WLAN_INTERFACE=$wlan_interace polybar --reload main &
    fi
  done
else
  polybar --reload example &
fi

echo "Bars launched..."
