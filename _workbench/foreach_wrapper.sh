#!/bin/bash

while getopts "d:" option; do
  case $option in
    d)
      directory=$OPTARG
      ;;
    *)
      echo "Invalid option: -$OPTARG"
      exit 1
      ;;
  esac
done

if [ -z "$directory" ]; then
  echo "Please specify a directory using the -d option."
  exit 1
fi

if [ ! -d "$directory" ]; then
  echo "Directory not found: $directory"
  exit 1
fi

for subdirectory in "$directory"/*/; do
  if [ -d "$subdirectory" ]; then
    echo "Running example.sh for subdirectory: $subdirectory"
    # cd "$subdirectory" || exit 1
    bash ~/Workspace/utilities/_workbench/log_current_filename.sh -d "$subdirectory"
    # cd - || exit 1
  fi
done
