#!/bin/bash

. ./utils.sh

if ! command_exists nvim ; then
  # for you complete me
  sudo apt-get install -y silversearcher-ag
  sudo apt-get install -y cmake

  sudo apt-get install -y python-dev python-pip python3-dev python3-pip \
    && python2 -m pip install neovim \
    && python3 -m pip install neovim
  curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
  chmod u+x nvim.appimage
  mv ./nvim.appimage ~/apps/nvim
  sudo ln -s ~/apps/nvim /usr/local/bin

  sudo apt-get intsall -y curl
  sudo curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  ln -s "$dotfil3s_root"nvim ~/.config/

  ~/apps/nvim -c "PlugInstall|q|q"
else
  echo "nvim already installed"
fi
