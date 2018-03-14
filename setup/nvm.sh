#!/bin/bash

NVM_DIR=~/nvm

if [ -d $NVM_DIR ]; then
  echo "installing nvm"
  # nvm environment variables
  NODE_VERSION=8.9.0

  sudo apt-get install -y curl

  # install nvm
  # https://github.com/creationix/nvm#install-script
  curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash

  # install node and npm
  source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

  # add node and npm to path so the commands are available
  export NODE_PATH=$NVM_DIR/v$NODE_VERSION/lib/node_modules
  export PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
else
  echo "nvm already installed"
fi
