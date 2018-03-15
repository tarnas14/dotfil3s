#!/bin/bash

links=(
  'https://github.com/meetfranz/franz/releases/download/v5.0.0-beta.16/franz_5.0.0-beta.16_amd64.deb'
  'https://getrambox.herokuapp.com/download/linux_64?filetype=deb'
  'https://www.dropbox.com//download?dl=packages/ubuntu/dropbox_2015.10.28_amd64.deb'
)

for d in ${links[@]}; do
  wget -O package.deb $d
  sudo dpkg -i package.deb
  rm package.deb
done

sudo apt-get install -f
