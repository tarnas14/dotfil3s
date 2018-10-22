#!/bin/bash
inotifywait -m $1 -e create |
  while read path action file; do
    if [[ "$file" =~ .*webm$ ]]; then
      filename="${file%.*}"
      input_path="$1/$file"
      output_path="$1/$filename.gif"
      ffmpeg -i $input_path -pix_fmt rgb24 $output_path && rm $input_path
    fi
  done
