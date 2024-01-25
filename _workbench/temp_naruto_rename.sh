#!/usr/bin/env bash

: '
Script: renaming_script.sh
Description: This script renames all files in the specified directory to the format "Naruto - E{number}" where {number} is a three-digit integer with leading zeros.
Usage: renaming_script.sh -d <directory>
Arguments:
  -d <directory>: Specifies the directory to rename files
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

count=1

for file in *; do
  if [[ -f $file ]]; then
    extension="${file##*.}"
    new_name="Naruto - E$(printf "%03d" "$count").$extension"
    mv "$file" "$new_name"
    ((count++))
  fi
done

echo "File renaming completed."

