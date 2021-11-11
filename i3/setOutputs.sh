#!/bin/bash

MONITOR_OUTPUT=$1
LAPTOP_OUTPUT=$2
MODE=$3

function alwaysTwo(){
  i3-msg "workspace 6, move workspace to output $MONITOR_OUTPUT"
  i3-msg "workspace 7, move workspace to output $MONITOR_OUTPUT"
  i3-msg "workspace 8, move workspace to output $MONITOR_OUTPUT"
  i3-msg "workspace 9, move workspace to output $MONITOR_OUTPUT"
  i3-msg "workspace 10, move workspace to output $MONITOR_OUTPUT"
}

function onlyOne(){
  i3-msg "workspace 6, move workspace to output $LAPTOP_OUTPUT"
  i3-msg "workspace 7, move workspace to output $LAPTOP_OUTPUT"
  i3-msg "workspace 8, move workspace to output $LAPTOP_OUTPUT"
  i3-msg "workspace 9, move workspace to output $LAPTOP_OUTPUT"
  i3-msg "workspace 10, move workspace to output $LAPTOP_OUTPUT"
}

function connect(){
  if [ $MODE = "right" ]; then
    echo "right"
    xrandr --output $MONITOR_OUTPUT --auto --right-of $LAPTOP_OUTPUT --auto
    # alwaysTwo
  elif [ $MODE = "left" ]; then
    echot "left"
    xrandr --output $MONITOR_OUTPUT --auto --left-of $LAPTOP_OUTPUT --auto
    # alwaysTwo
  elif [ $MODE = "mirror" ]; then
    echo "mirror"
    xrandr --output $MONITOR_OUTPUT --auto --same-as $LAPTOP_OUTPUT --auto
    # alwaysTwo
  elif [ $MODE = "onlyMonitor" ]; then
    echo "only"
    xrandr --output $MONITOR_OUTPUT --auto --output $LAPTOP_OUTPUT --off
  elif [ $MODE = "above" ]; then
    echo "above"
    xrandr --output $MONITOR_OUTPUT --auto --above $LAPTOP_OUTPUT --auto
    # alwaysTwo
  else
    echo "else"
    xrandr --output $MONITOR_OUTPUT --off --output $LAPTOP_OUTPUT --auto
    # onlyOne
  fi
}

function disconnect(){
  echo "disconnect"
  xrandr --output $MONITOR_OUTPUT --off --output $LAPTOP_OUTPUT --auto
  # onlyOne
}

if [ "$(xrandr | grep -q '$MONITOR_OUTPUT connected 1920x1080'))" -ge 0 ]; then
  disconnect
else
  connect
fi
