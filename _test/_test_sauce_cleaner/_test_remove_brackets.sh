#!/usr/bin/env bash

# File Renaming Script: Remove Characters and Whitespaces
#
# Name (Official): file_renaming_script.sh
# Name (Unofficial): sauce_cleaner.sh
#
# This script renames files in a specified directory by removing characters
# after the first closing bracket if the first character is an opening bracket,
# and removing everything after the first whitespace character if the first
# character is not an opening bracket. 
# The script also removes any square brackets from the filenames. 
# The renamed file names are logged to a log file for future reference.
#
# Usage: ./file_renaming_script.sh -d <directory>
#
# Options:
#   -d <directory>: Specify the directory containing the files to be renamed.
#
# Example: ./file_renaming_script.sh -d /path/to/files
#
# Note: This script only renames files in the specified directory and does not
# modify files in subdirectories.
#
# Author: Seung Ki Lee
# Date: 2024/01/06

# Parse command line arguments
while getopts "d:" option; do
  case $option in
    d) directory=$OPTARG ;;
    *) echo "잘못된 옵션입니다. 스크립트를 다시 실행하세요." >&2
       exit 1 ;;
  esac
done

# Check if directory is provided
if [ -z "$directory" ]; then
  echo "디렉토리를 지정해야 합니다. -d 옵션을 사용하세요." >&2
  exit 1
fi

# Set test flag (true or false)
test_flag=false

# Create or append to the log file if test flag is true
if $test_flag; then
  # Define log file name with current timestamp
  timestamp=$(date +"%Y_%m_%d_%H_%M_%S")
  log_file="log_${timestamp}.txt"
  
  echo "파일 이름 변경 결과:" >> "$log_file"
fi

# Iterate over files in the directory
for file in "$directory"/*; do
  if [ -f "$file" ]; then
    file_name=$(basename "$file")
    extension="${file_name##*.}"
    file_name_without_extension="${file_name%.*}"
    new_name="$file_name_without_extension"

    # Remove characters after the first closing bracket if the first character is an opening bracket
    if [[ $new_name == [* ]]; then
      new_name="${new_name%%]*}"
    fi

    # Remove everything after the first whitespace character if the first character is not an opening bracket
    if [[ $new_name != [* ]]; then
      new_name="${new_name%%[[:space:]]*}"
    fi

    # Remove brackets
    new_name="${new_name//[\[\]]/}"

    new_name="$new_name.$extension"

    if [ "$file_name" != "$new_name" ]; then
      mv "$file" "$directory/$new_name"
      echo "파일 이름이 변경되었습니다: $file -> $directory/$new_name"

      # Append to the log file if test flag is true
      if $test_flag; then
        echo "파일 이름이 변경되었습니다: $file -> $directory/$new_name" >> "$log_file"
      fi
    fi
  fi
done

# Print the file renaming results from the log file if test flag is true
if $test_flag; then
  echo "파일 이름 변경 결과:"
  cat "$log_file"
fi