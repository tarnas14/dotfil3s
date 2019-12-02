#!/usr/bin/env bash

source=$1
target=${1%.*}.gif

ffmpeg -i $source -pix_fmt rgb24 $target && rm -rf $source
