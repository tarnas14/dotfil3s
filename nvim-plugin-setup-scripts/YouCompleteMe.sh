#!/bin/bash

readonly youCompleteMePath=~/.config/nvim/plugged/YouCompleteMe

if [ ! -e "$youCompleteMePath" ]; then
  echo "run this script only after installing nvim and running :PlugInstall, pl0x"
  exit
fi

alreadyInstalled=false
installYouCompleteMe=true

if [ -e "$youCompleteMePath/installed" ]; then
  alreadyInstalled=true
  installYouCompleteMe=false
fi

if [[ $1 == "reinstall" ]]; then
  installYouCompleteMe=true
fi

if [[ $installYouCompleteMe == true ]]; then
  sudo apt-get install -y build-essential cmake
  nvm install node
  npm i -g typescript
  cd $youCompleteMePath; git submodule update --init --recursive
  cd $youCompleteMePath; ./install.py --tern-completer
  cd $youCompleteMePath; touch installed
  exit
fi

if [ $alreadyInstalled ]; then
  echo "YouCompleteMe is already installed, add 'reinstall' as first argument to force reinstall"
fi
