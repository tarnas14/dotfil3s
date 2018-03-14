#!/bin/bash

. ../utils.sh

if ! command_exists tlp ; then
  echo "installing tlp"
  sudo add-apt-repository ppa:linrunner/tlp
  sudo apt-get update
  sudo apt-get -y install tlp tlp-rdw smartmontools ethtool
else
  echo "tlp already installed"
fi
