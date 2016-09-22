#!/bin/bash

command_exists () {
    type "$1" &> /dev/null ;
}

if ! command_exists nvim ; then
  echo "installing nvim"
  sudo apt-get install -y software-properties-common &> /dev/null
  sudo apt-get install -y python-dev python-pip python3-dev python3-pip &> /dev/null
  sudo python2 -m pip install neovim
  sudo python3 -m pip install neovim
  sudo add-apt-repository ppa:neovim-ppa/unstable
  sudo apt-get update
  sudo apt-get install xclip
  sudo apt-get install -y neovim
else
  echo "nvim already installed"
fi

