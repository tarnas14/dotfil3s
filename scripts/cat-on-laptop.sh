#!/bin/bash

function getValueFromConfig {
  awk "/^${1}:.*$/" ~/.catonlaptop | cut -d ":" -f2
}

function getXinputId {
  paste <(xinput list --name-only) <(xinput list --id-only) | awk "/$1/" | awk -F '\t' '{print $2}'
}

case "$1" in
  --off)
    xinput float $(getXinputId "$(getValueFromConfig 'touchpad')")
    xinput float $(getXinputId "$(getValueFromConfig 'keyboard')")
    ;;
  --on)
    touchpadId=$(getXinputId "$(getValueFromConfig 'touchpad')")
    xinput reattach ${touchpadId:2:3} $(getXinputId "$(getValueFromConfig 'pointer-master')")
    keyboardId=$(getXinputId "$(getValueFromConfig 'keyboard')")
    xinput reattach ${keyboardId:2:3} $(getXinputId "$(getValueFromConfig 'keyboard-master')")
    ;;
esac

