#!/usr/bin/env bash

ffmpeg -i $1 -pix_fmt rgb24 $2

rm -rf $1
