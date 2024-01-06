#!/usr/bin/env bash

# Script to run a subdirectory script on each subdirectory

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

# Set test flag (true or false)
test_flag=false

# Get the list of subdirectories
subdirectories=$(find "$directory" -maxdepth 1 -type d)

# Loop through each subdirectory
for subdirectory in $subdirectories; do
  # Skip the main directory itself
  if [ "$subdirectory" != "$directory" ]; then
    # Check if the subdirectory is empty
    if [ -z "$(ls -A "$subdirectory")" ]; then
      echo "Skipping empty subdirectory: $subdirectory"
    else
      # Run your subdirectory script here
      
      if $test_flag; then
        # In Test
        ./test_remove_brackets.sh -d "$subdirectory"
      else
        # In Prod
        ./sauce_cleaner.sh -d "$subdirectory"
      fi

      echo "Running script on subdirectory: $subdirectory"
    fi
  fi
done