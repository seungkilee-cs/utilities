#!/usr/bin/env bash

: '
This script adds corresponding SRT subtitles to MP4 videos in a specified directory, 
converts the videos to MKV format, and then sets the subtitle info.

Usage: bash add_subtitles.sh -d directory_path

Options:
-d    Path of the target directory (required)
-h    Print Help Message
'

print_help() {
  echo "$(grep '^: ' "$0" | cut -c3-)"
}

while getopts d:h flag
do
    case "${flag}" in
        d) dir=${OPTARG};;  # Set the target directory
        h) print_help; exit;;  # Print the help message and exit
    esac
done

if [ -z "$dir" ]; then
  echo "Error: The -d option is required."
  print_help
  exit 1
fi

cd "$dir" || exit

for mp4_file in *.mp4; do
  base_name=$(basename "$mp4_file" .mp4)
  srt_file="${base_name}.srt"

  if [ -f "$srt_file" ]; then
    ffmpeg -i "$mp4_file" -i "$srt_file" -c copy -scodec ass "_${base_name}.ass.mkv"
    mkvmerge -o "_${base_name}.ko.mkv" --language 0:kor --track-order 0:1,0:2,1:0 "_${base_name}.ass.mkv"
    # mkvpropedit "_${base_name}.ko.mkv" --edit track:s1 --set language=kor --set name="[Korean] Korean" --set flag-default=1
        mkvpropedit "_${base_name}.ko.mkv" --edit track:s1 --set language=kor --set flag-default=1
    rm "_${base_name}.ass.mkv"
  fi
done
