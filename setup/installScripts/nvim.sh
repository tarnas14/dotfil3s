#!/bin/bash

. ../utils.sh 

if ! command_exists nvim ; then
  echo "installing nvim"
  sudo apt-get install -y software-properties-common &> /dev/null
  sudo apt-get install -y python-dev python-pip python3-dev python3-pip &> /dev/null
  sudo apt-get install -y software-properties-common
  sudo apt-get install -y python-dev python-pip python3-dev python3-pip
  sudo python2 -m pip install neovim
  sudo python3 -m pip install neovim
  sudo add-apt-repository ppa:neovim-ppa/unstable
  sudo apt-get update
  sudo apt-get install -y xclip
  sudo apt-get install -y neovim

  mkdir -p ~/.config
  rm -rf ~/.config/nvim
  ln -s "$dotfil3s_root"nvim ~/.config/nvim

  echo "installing plug (plugin manager)"
  curl -fLo ../../nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  wait_for_user "nvim and plug installed, now go there and run :PlugInstall"

  echo "setting up plugins and stuff"
  for script in ./nvim-plugin-setup-scripts/*
  do
    if [ -f $script -a -x $script ]
    then
      $script
    fi
  done
else
  echo "nvim already installed"
fi
