#!/usr/bin/env bash

: '
Script: directory_log.sh
Description: This script logs the name of the current directory and the file names (including extensions) of all files within it.
Usage: directory_log.sh -d <directory>
Arguments:
  -d <directory>: Specifies the directory to log
'

while getopts "d:" opt; do
  case $opt in
    d)
      directory=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

if [[ -z $directory ]]; then
  echo "Please provide a directory using the -d option."
  exit 1
fi

if [[ ! -d $directory ]]; then
  echo "Directory not found: $directory"
  exit 1
fi

cd "$directory" || exit 1

current_dir=$(basename "$directory")
log_file="$current_dir.txt"

echo "Current Directory: $current_dir" > "$log_file"
echo "-----------------------------" >> "$log_file"

find . -type f | while read -r file; do
  filename=$(basename "$file")
  echo "$filename" >> "$log_file"
done

echo "Log file created: $directory/$log_file"
