#!/bin/bash

MONITOR_OUTPUT=$1
LAPTOP_OUTPUT=$2
MODE=$3


function connect(){
  if [ $MODE = "right" ]; then
    xrandr --output $MONITOR_OUTPUT --right-of $LAPTOP_OUTPUT --auto
  else
    xrandr --output $MONITOR_OUTPUT --above $LAPTOP_OUTPUT --auto
  fi
}
  
function disconnect(){
  xrandr --output $MONITOR_OUTPUT --off
}

xrandr | grep "$MONITOR_OUTPUT connected" &> /dev/null && connect || disconnect
