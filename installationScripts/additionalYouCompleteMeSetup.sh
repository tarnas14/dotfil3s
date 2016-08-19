#!/bin/bash

readonly youCompleteMePath=~/.config/nvim/plugged/YouCompleteMe

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
  cd $youCompleteMePath; ./install.py --tern-completer
  cd $youCompleteMePath; touch installed
  exit
fi

if [ $alreadyInstalled ]; then
  echo "YouCompleteMe is already installed, add 'reinstall' as first argument to force reinstall"
fi
