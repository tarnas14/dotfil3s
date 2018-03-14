#!/bin/bash

. ./utils.sh

if ! command_exists nvim ; then
  sudo apt-get install -y python-dev python-pip python3-dev python3-pip \
    && python2 -m pip install neovim \
    && python3 -m pip install neovim \
    && add-apt-repository -y ppa:neovim-ppa/unstable \
    && apt-get update \
    && apt-get install -y neovim

  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  ln -s "$dotfil3s_root"nvim ~/.config/

  nvim -c "PlugInstall|q|q"
else
  echo "nvim already installed"
fi
