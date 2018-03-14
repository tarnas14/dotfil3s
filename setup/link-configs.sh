#!/bin/bash

. ./utils.sh

rm -f ~/.gitconfig
ln -s "$dotfil3s_root".gitconfig ~/.gitconfig
rm -f ~/.gitignore_global
ln -s "$dotfil3s_root".gitignore_global ~/.gitignore_global
rm -f ~/.zshrc
ln -s "$dotfil3s_root".zshrc ~/.zshrc
