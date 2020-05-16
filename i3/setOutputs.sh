#!/bin/bash

MONITOR_OUTPUT=$1
LAPTOP_OUTPUT=$2
MODE=$3


function connect(){
  if [ $MODE = "right" ]; then
    xrandr --output $MONITOR_OUTPUT --auto --right-of $LAPTOP_OUTPUT --auto
  elif [ $MODE = "left" ]; then
    xrandr --output $MONITOR_OUTPUT --auto --left-of $LAPTOP_OUTPUT --auto
  elif [ $MODE = "mirror" ]; then
    xrandr --output $MONITOR_OUTPUT --auto --same-as $LAPTOP_OUTPUT --auto
  elif [ $MODE = "onlyMonitor" ]; then
    xrandr --output $MONITOR_OUTPUT --auto --output $LAPTOP_OUTPUT --off
  elif [ $MODE = "above" ]; then
    xrandr --output $MONITOR_OUTPUT --auto --above $LAPTOP_OUTPUT --auto
  else
    xrandr --output $MONITOR_OUTPUT --off --output $LAPTOP_OUTPUT --auto
  fi
}

function disconnect(){
  xrandr --output $MONITOR_OUTPUT --off --output $LAPTOP_OUTPUT --auto
}

xrandr | grep "$MONITOR_OUTPUT connected" &> /dev/null && connect || disconnect
