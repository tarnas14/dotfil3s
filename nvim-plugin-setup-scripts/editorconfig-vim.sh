#!/bin/bash

command_exists () {
    type "$1" &> /dev/null ;
}

if ! command_exists editorconfig ; then
  echo "installing editorconfig core"
  sudo apt-get install editorconfig -y &> /dev/null
else
  echo "editorconfig already installed"
fi
