#!/bin/bash

sudo pacman -S --noconfirm tmux

rm -f ~/.tmux.conf
ln -s ~/dotfil3s/.tmux.conf ~/.tmux.conf
