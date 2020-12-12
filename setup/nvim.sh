#!/bin/bash

sudo pacman -S the_silver_searcher --needed --noconfirm
yay -S --noconfirm vim-plug
sudo pacman -S neovim --needed --noconfirm
sudo pacman -S python-pynvim --needed --noconfirm

rm -rf ~/.config/nvim
ln -s ~/dotfil3s/nvim ~/.config/nvim

nvim -c "PlugInstall|q|q"
