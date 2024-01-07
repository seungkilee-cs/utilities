#!/usr/bin/env bash

# Script: unlock_files.sh
#
# Description: This script recursively searches for files in a specified directory and unlocks any locked files it finds.
#              It is useful when you encounter locked files and need to modify or delete them.
#
# Usage: unlock_files.sh [option] -d <directory>
#
# Options:
#   -d <directory>   The directory path where the script will search for locked files.
#   -h, --help       Display this help message.
#
# Example: unlock_files.sh -d /path/to/directory
#
# Note: This script requires Bash to run. Make sure the script is executable (chmod +x unlock_files.sh) before running it.
#       Only regular files (not symbolic links) are considered for unlocking.
#       The script uses the chflags command to unlock files on macOS. It may require appropriate permissions to modify file flags.
#       Use this script with caution, as unlocking files may have unintended consequences.
#
# Author: [Your Name]
# Date: [Current Date]

usage() {
  echo "Usage: $0 [option] -d <directory>"
  echo ""
  echo "Options:"
  echo "  -d <directory>   The directory path where the script will search for locked files."
  echo "  -h, --help       Display this help message."
  exit 1
}

unlock_files() {
  local directory="$1"
  find "$directory" -type f | while read -r file_path; do
    if [[ -f "$file_path" ]]; then
      if [[ -L "$file_path" ]]; then
        echo "Skipping symbolic link: $file_path"
      elif [[ -w "$file_path" ]]; then
        echo "File is not locked: $file_path"
      else
        # Unlock the file
        chflags nouchg "$file_path"
        if [[ $? -eq 0 ]]; then
          echo "Unlocked file: $file_path"
        else
          echo "Error unlocking file: $file_path"
        fi
      fi
    fi
  done
}

# Parse command-line options
while getopts ":d:h" opt; do
  case $opt in
    d)
      directory_path="$OPTARG"
      ;;
    h)
      usage
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      usage
      ;;
    :)
      echo "Option -$OPTARG requires an argument."
      usage
      ;;
  esac
done

# Check if the directory option is provided
if [[ -z "$directory_path" ]]; then
  echo "Directory option -d is mandatory."
  usage
fi

# Check if the specified directory exists
if [[ ! -d "$directory_path" ]]; then
  echo "Directory does not exist: $directory_path"
  exit 1
fi

unlock_files "$directory_path"