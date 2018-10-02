#!/bin/bash

# dependencies
sudo apt-get install scrot -y
sudo apt-get install rofi -y
sudo apt-get install help2man -y

# light
echo "to install light:"
echo "git submodule update"
echo "cd i3/light"
echo "make && sudo make install"

wget -O package.deb "https://github.com/acrisci/playerctl/releases/download/v0.6.0/playerctl-0.6.0_amd64.deb"
sudo dpkg -i package.deb
rm package.deb

sudo apt-get install -f
