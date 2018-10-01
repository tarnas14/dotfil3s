#!/bin/bash

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.4.3
# we need to reload zsh here cause it has no idea about it
asdf plugin-add nodejs
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf install nodejs 8.9.4
asdf global nodejs 8.9.4
