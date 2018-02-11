FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install -y silversearcher-ag \
    && apt-get install -y curl \
    && apt-get install -y git-core \
    && apt-get install -y software-properties-common \
    && apt-get install -y build-essential cmake \
    && add-apt-repository -y ppa:neovim-ppa/unstable \
    && apt-get update \
    && apt-get install -y neovim python-dev python-pip \
    && apt-get -y autoclean

RUN apt-get install -y tmux

# replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# nvm environment variables
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 8.9.4

# install nvm
# https://github.com/creationix/nvm#install-script
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash

# install node and npm
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# confirm installation
RUN node -v
RUN npm -v

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd -m tarnasenv -s /bin/bash

COPY ./nvim/init.vim /home/tarnasenv/.config/nvim/
RUN chown -R tarnasenv:tarnasenv /home/tarnasenv/.config

USER tarnasenv
WORKDIR /home/tarnasenv

RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# RUN ["nvim", "-c", "PlugInstall|q|q"]
RUN nvim -c "PlugInstall|q|q"

ENTRYPOINT tmux
