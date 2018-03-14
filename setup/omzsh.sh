#!/bin/bash

if [ $SHELL != "/usr/bin/zsh" ]; then
  echo "zsh already installed, probably oh my zsh is already there"
else
  sudo apt-get -y install zsh
  wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
  chsh -s `which zsh`
fi
