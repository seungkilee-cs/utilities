#!/usr/bin/env bash

# Parse command-line arguments
while getopts "d:" opt; do
  case $opt in
    d)
      directory=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument."
      exit 1
      ;;
  esac
done

# Check if directory is provided
if [ -z "$directory" ]; then
  echo "Please provide a directory using the -d flag."
  exit 1
fi

# Validate if the directory exists
if [ ! -d "$directory" ]; then
  echo "The specified directory does not exist."
  exit 1
fi

# For Testing regarding filenames
for i in {1..5}; do touch "$directory/[file-$i-1] - This is a gonner.txt"; done
for i in {1..5}; do touch "$directory/[file-$i-2] [This Should be gone too].txt"; done
for i in {1..5}; do touch "$directory/file-$i-3 This will be removed.txt"; done
for i in {1..5}; do touch "$directory/file-$i-4 This will be [removed].txt"; done