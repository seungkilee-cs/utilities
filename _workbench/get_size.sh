#!/usr/bin/env bash

: '
Prints out the file name, file extension, and file size for each file in a directory.

Usage: ./file_info.sh [-d DIRECTORY]

Options:
  -d DIRECTORY  Specify the directory to analyze (default: current directory)
'

# Function to calculate the length of the longest file name in a directory
get_longest_filename_length() {
  local longest_length=0
  
  for file in "$1"/*; do
    if [ -f "$file" ]; then
      filename=$(basename "$file")
      length=${#filename}
      
      if [ "$length" -gt "$longest_length" ]; then
        longest_length=$length
      fi
    fi
  done
  
  echo "$longest_length"
}

while getopts ":d:" opt; do
  case $opt in
    d)
      directory=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [ -z "$directory" ]; then
  directory="."  # If no directory is specified, use the current directory
fi

if [ ! -d "$directory" ]; then
  echo "Invalid directory: $directory"
  exit 1
fi

# Get the length of the longest file name
longest_filename_length=$(get_longest_filename_length "$directory")

# Calculate the width of the "File Name" column
filename_column_width=$((longest_filename_length + 2))

# # Generate the separator line dynamically
# separator_line=$(printf "%-${filename_column_width}s" "-" | tr ' ' '-')

# filename_header = "File Name" 

# echo "File Name | File Extension | File Size"
# echo "$separator_line"

for file in "$directory"/*; do
  if [ -f "$file" ]; then
    filename=$(basename "$file")
    extension="${filename##*.}"
    size=$(du -sh "$file" | awk '{print $1}')
    padded_filename=$(printf "%-${filename_column_width}s" "$filename")
    printf "%s | %s | %s\n" "$padded_filename" "$extension" "$size"
  fi
done