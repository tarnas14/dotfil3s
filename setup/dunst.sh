#!/bin/bash

yay -S --noconfirm dunst-git

rm -f ~/.config/dunst
ln -s ~/dotfil3s/dunst ~/.config/dunst
