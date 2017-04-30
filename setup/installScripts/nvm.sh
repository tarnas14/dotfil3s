#!/bin/bash

if [ ! -d "/home/tarnas/.nvm" ]; then
  echo "installing nvm"
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
  echo "should be installed, reloading zshrc and installing node"
  . ~/.zshrc
  nvim install node
else
  echo "nvm already installed"
fi
