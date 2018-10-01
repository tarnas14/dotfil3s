#!/bin/bash

if [ $SHELL == "/usr/bin/zsh" ]; then
  echo "zsh already installed, probably oh my zsh is already there"
else
  sudo apt-get -y install zsh
  wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh
  #sed -i.tmp 's:env zsh::g' install.sh
  #sed -i.tmp 's:chsh -s .*$::g' install.sh
  sh install.sh
  rm install.sh
fi
