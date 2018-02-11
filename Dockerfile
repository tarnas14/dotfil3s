FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install -y silversearcher-ag \
    && apt-get install -y wget \
    && apt-get install -y curl \
    && apt-get install -y git-core \
    && apt-get install -y software-properties-common \
    && apt-get install -y build-essential cmake \
    && apt-get install -y software-properties-common \
    && apt-get install -y python-dev python-pip python3-dev python3-pip \
    && python2 -m pip install neovim \
    && python3 -m pip install neovim \
    && add-apt-repository -y ppa:neovim-ppa/unstable \
    && apt-get update \
    && apt-get install -y neovim \
    && apt-get -y install libevent-dev \
    && apt-get -y install ncurses-dev \
    && apt-get -y autoclean

RUN apt-get install -y locales locales-all
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

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

RUN git clone https://github.com/tmux-plugins/tpm /home/tarnasenv/.tmux/plugins/tpm
RUN chown -R tarnasenv:tarnasenv /home/tarnasenv/.tmux

COPY ./.tmux.conf /home/tarnasenv/
RUN chown tarnasenv:tarnasenv /home/tarnasenv/.tmux.conf

# install tmux
RUN wget https://github.com/tmux/tmux/releases/download/2.3/tmux-2.3.tar.gz
RUN mkdir -p /home/tarnasenv/apps
RUN tar -zxf tmux-2.3.tar.gz -C /home/tarnasenv/apps
RUN rm tmux-2.3.tar.gz
RUN mv /home/tarnasenv/apps/tmux-2.3 /home/tarnasenv/apps/tmux
WORKDIR /home/tarnasenv/apps/tmux
RUN ./configure && make
RUN ln -s /home/tarnasenv/apps/tmux/tmux /usr/local/bin/tmux
RUN chown -R tarnasenv:tarnasenv /home/tarnasenv/apps

# maybe chown the whole home directory at the end?
# RUN chown tarnasenv:tarnasenv /home/tarnasenv/

USER tarnasenv
WORKDIR /home/tarnasenv

RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# RUN ["nvim", "-c", "PlugInstall|q|q"]
RUN nvim -c "PlugInstall|q|q"

ENTRYPOINT tmux
