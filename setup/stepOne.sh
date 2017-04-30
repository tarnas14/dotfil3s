#!/bin/bash

. ./utils.sh

echo "installing zsh and setting it as default shell"
sudo apt-get -y install zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
chsh -s `which zsh`
wait_for_user "zsh should be your default shell now, this needs a restart"
sudo shutdown -r 0
