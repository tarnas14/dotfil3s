#!/bin/bash

. ./utils.sh

rm -f ~/.gitconfig
ln -s "$dotfil3s_root".gitconfig ~/.gitconfig
rm -f ~/.gitignore_global
ln -s "$dotfil3s_root".gitignore_global ~/.gitignore_global
rm -f ~/.zshrc
ln -s "$dotfil3s_root".zshrc ~/.zshrc
rm -f ~/.nethackrc
ln -s "$dotfil3s_root".nethackrc ~/.nethackrc
rm -rf ~/.config/i3
ln -s "$dotfil3s_root"i3 ~/.config/i3
rm -rf ~/.config/i3status
ln -s "$dotfil3s_root"i3status ~/.config/i3status
