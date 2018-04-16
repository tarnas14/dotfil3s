#!/bin/bash

# dependencies
sudo apt-get install scrot -y
sudo apt-get install rofi -y

wget -0 package.deb "https://github.com/acrisci/playerctl/releases/download/v0.6.0/playerctl-0.6.0_amd64.deb"
sudo dpkg -i package.deb
rm package.deb

sudo apt-get install -f
