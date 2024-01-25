#!/usr/bin/env bash

: '
This script adds corresponding SRT subtitles to MKV videos in a specified directory.
The subtitles are set to Korean and named "[Korean] Korean".

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
        *) print_help; exit;;  # Print the help message and exit
    esac
done

if [ -z "$dir" ]; then
  echo "Error: The -d option is required."
  print_help
  exit 1
fi

cd "$dir" || exit

for mkv_file in *.mkv; do
  base_name=$(basename "$mkv_file" .mkv)
  srt_file="${base_name}.srt"

  if [ -f "$srt_file" ]; then
    echo "Processing file: $mkv_file"
    # Add the new subtitle track and set its language to Korean
    new_file="new_${base_name}.mkv"
    mkvmerge -o "$new_file" --language 0:kor "$mkv_file" "$srt_file"
    echo "Added a new subtitle track to: $new_file"
    
    mkvpropedit "$new_file" --edit track:s10 --set name="Korean" --set language=kor
    
    # # Print the subtitle tracks of the new file
    # echo "Subtitle tracks in $new_file:"
    # mkvinfo "$new_file"
  fi
done