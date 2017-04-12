#!/bin/bash

command_exists () {
    type "$1" &> /dev/null ;
}

if ! command_exists tlp ; then
  echo "installing tlp"
  sudo add-apt-repository ppa:linrunner/tlp
  sudo apt-get update
  sudo apt-get -y install tlp tlp-rdw smartmontools ethtool
else
  echo "tlp already installed"
fi

# yes, assuming 'tarnas' user, give me a break
if [ ! -d "/home/tarnas/apps" ]; then 
  mkdir ~/apps
fi

if ! command_exists tmux ; then
  echo "installing tmux"
  sudo apt-get -y install libevent-dev
  sudo apt-get -y install ncurses-dev
  cd ~/Downloads
  wget https://github.com/tmux/tmux/releases/download/2.3/tmux-2.3.tar.gz
  tar -zxf tmux-2.3.tar.gz -C ~/apps
  rm tmux-2.3.tar.gz
  cd ~/apps
  mv tmux-2.3 tmux
  cd tmux
  ./configure && make
  sudo ln -s ~/apps/tmux/tmux /usr/local/bin/tmux
else
  echo "tmux already installed"
fi

if ! command_exists curl ; then
  echo "installing curl"
  sudo apt-get -y install curl
fi

if [ ! -d "/home/tarnas/.nvm" ]; then
  echo "installing nvm"
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
else
  echo "nvm already there"
fi

if ! command_exists nvim ; then
  echo "installing nvim"
  sudo apt-get install -y software-properties-common
  sudo apt-get install -y python-dev python-pip python3-dev python3-pip
  sudo python2 -m pip install neovim
  sudo python3 -m pip install neovim
  sudo add-apt-repository ppa:neovim-ppa/unstable
  sudo apt-get update
  sudo apt-get -y install xclip
  sudo apt-get -y install neovim
else
  echo "nvim already installed"
fi
