#!/bin/bash

yay -S --noconfirm oh-my-zsh-git
echo 'n' | /usr/share/oh-my-zsh/tools/install.sh

rm -f ~/.zshrc
ln -s ~/dotfil3s/.zshrc ~/.zshrc
