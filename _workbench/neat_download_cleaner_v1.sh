#!/usr/bin/env bash

: '
This script changes the names of all files in a specified directory.
It capitalizes all characters before the first space character in each filename,
and changes the first space character to a "-".

Usage: bash neat_download_cleaner_v1.sh -d directory_path

Options:
-d    Path of the target directory (required)
-h    Print this help message
'

# Print the help message
print_help() {
  echo "$(grep '^: ' "$0" | cut -c3-)"
}

# Parse the options
while getopts d:h flag
do
    case "${flag}" in
        d) dir=${OPTARG};;  # Set the target directory
        h) print_help; exit;;  # Print the help message and exit
    esac
done

# Check if the -d option was provided
if [ -z "$dir" ]; then
  echo "Error: The -d option is required."
  print_help
  exit 1
fi

# Navigate to the target directory
cd "$dir" || exit

# Iterate over all files in the directory
for file in *; do
  # Extract the prefix of the filename (before the first space)
  prefix=$(echo $file | awk '{print $1}')
  # Extract the rest of the filename (after the first space), remove leading space
  suffix=$(echo $file | awk '{$1=""; sub(/^[ \t]+/, ""); print $0}')
  # Capitalize the prefix
  new_prefix=$(echo $prefix | tr '[:lower:]' '[:upper:]')
  # Construct the new filename
  new_file="${new_prefix}-${suffix}"
  # Rename the file
  mv "$file" "$new_file"
done
