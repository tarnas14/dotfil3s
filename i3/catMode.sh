#!/bin/bash

# check `xinput list` to look for input ID and slave ID
TOUCHPAD_ID=${TOUCHPAD_ID:-20} # SynPS/2 Synaptics TouchPad
TRACKPOINT_ID=${TRACKPOINT_ID:-21} # TPPS/2 Elan TrackPoint
TOUCHPAD_TRACKPOINT_SLAVE_ID=${TOUCHPAD_TRACKPOINT_SLAVE_ID:-2}

KEYBOARD_ID=${KEYBOARD_ID:-19} # AT Translated Set 2 keyboard
EXTRA_BUTTONS_ID=${EXTRA_BUTTONS_ID:-22} # ThinkPad Extra Buttons
KEYBOARD_SLAVE_ID=${KEYBOARD_SLAVE_ID:-3}

CAT_MODE_IS_ON=$(xinput list | grep $KEYBOARD_ID | grep 'floating')

ACTION=${1:-'on'}

function on(){
    echo "turning cat mode on"
    xinput float $TOUCHPAD_ID;
    xinput float $TRACKPOINT_ID;
    xinput float $KEYBOARD_ID;
    xinput float $EXTRA_BUTTONS_ID;
}

function off(){
    echo "turning cat mode off"
    xinput reattach $TOUCHPAD_ID $TOUCHPAD_TRACKPOINT_SLAVE_ID;
    xinput reattach $TRACKPOINT_ID $TOUCHPAD_TRACKPOINT_SLAVE_ID;
    xinput reattach $KEYBOARD_ID $KEYBOARD_SLAVE_ID;
    xinput reattach $EXTRA_BUTTONS_ID $KEYBOARD_SLAVE_ID;
}

if [ $ACTION = "toggle" ]; then
  if [ -z "$CAT_MODE_IS_ON" ]; then
    on
  else
    off
  fi
elif [ $ACTION = "off" ]; then
  off
elif [ $ACTION = "check" ]; then
  if [ -z "$CAT_MODE_IS_ON" ]; then
    echo "CM: OFF"
  else
    echo "CM: ON"
  fi
else
  on
fi
