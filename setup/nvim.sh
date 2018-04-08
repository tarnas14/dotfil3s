#!/bin/bash

. ./utils.sh

if ! command_exists nvim ; then
  # for you complete me
  sudo apt-get install -y silversearcher-ag
  sudo apt-get install -y cmake

  sudo apt-get install -y python-dev python-pip python3-dev python3-pip \
    && python2 -m pip install neovim \
    && python3 -m pip install neovim
  sudo add-apt-repository -y ppa:neovim-ppa/unstable
  sudo apt-get update
  sudo apt-get install -y neovim

  sudo curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  ln -s "$dotfil3s_root"nvim ~/.config/

  nvim -c "PlugInstall|q|q"
else
  echo "nvim already installed"
fi
