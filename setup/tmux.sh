#!/bin/bash

. ./utils.sh

if ! command_exists tmux ; then
  # mkdir -p ~/apps

  # echo "installing tmux"
  # sudo apt-get -y install libevent-dev
  # sudo apt-get -y install ncurses-dev
  # sudo apt-get -y install wget
  # wget https://github.com/tmux/tmux/releases/download/2.3/tmux-2.3.tar.gz
  # tar -zxf tmux-2.3.tar.gz -C ~/apps
  # rm tmux-2.3.tar.gz
  # cd ~/apps
  # mv tmux-2.3 tmux
  # cd tmux
  # ./configure && make
  # sudo ln -s ~/apps/tmux/tmux /usr/local/bin/tmux

  snap install tmux --classic

  echo "linking tmux conf"
  rm ~/.tmux.conf
  ln -s "$dotfil3s_root".tmux.conf ~/.tmux.conf

  echo "tmux installed, plugins will be installed on first run"
else
  echo "tmux already installed"
fi
