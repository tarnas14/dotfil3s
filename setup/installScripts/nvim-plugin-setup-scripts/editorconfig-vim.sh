#!/bin/bash

. ../utils.sh

if ! command_exists editorconfig ; then
  echo "installing editorconfig core"
  sudo apt-get install editorconfig -y &> /dev/null
else
  echo "editorconfig already installed"
fi
