#!/bin/bash

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.4.3
asdf plugin-add nodejs
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf install nodejs 8.9.4
asdf global nodejs 8.9.4
