#!/bin/bash

LAPTOP_OUTPUT=${1:-"eDP-1"}
MONITOR_OUTPUT=${2:-"HDMI-1"}

function connect(){
  xrandr --output $MONITOR_OUTPUT --right-of $LAPTOP_OUTPUT --auto
}
  
function disconnect(){
  xrandr --output $MONITOR_OUTPUT --off
}

xrandr | grep "$MONITOR_OUTPUT connected" &> /dev/null && connect || disconnect
