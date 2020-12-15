#!/usr/bin/env sh

if ! type "xrandr" &> /dev/null ; then
  echo "showing polybar only for if X-11 is present"
  exit 1
fi

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

lan_interface=$(ip link show | awk -F ':' '{print $2}' | grep 'en' | xargs)
wlan_interace=$(ip link show | awk -F ':' '{print $2}' | grep 'wl' | xargs)

monitors=($(xrandr --query | grep " connected" | cut -d" " -f1))
monitorsNumber=${#monitors[@]}

# if there is only one output, show main status bar
if [ $monitorsNumber == 1 ]; then
  MONITOR=$m LAN_INTERFACE=$lan_interface WLAN_INTERFACE=$wlan_interace polybar --reload main &
  exit 0
fi

# if there is more than one output, show main status bar on laptop screen
# and secondary status bars on others
for (( i=0; i<${monitorsNumber}; i++ ));
do
  m=${monitors[$i]}
  if [[ "$m" == *"eDP"* ]]; then
    MONITOR=$m LAN_INTERFACE=$lan_interface WLAN_INTERFACE=$wlan_interace polybar --reload main &
  else
    MONITOR=$m LAN_INTERFACE=$lan_interface WLAN_INTERFACE=$wlan_interace polybar --reload secondary &
  fi
done

exit 0
