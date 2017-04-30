#!/bin/bash

. ../utils.sh 

if ! command_exists curl ; then
  echo "installing curl"
  sudo apt-get update
  sudo apt-get -y install curl
else
  echo "curl already installed"
fi
