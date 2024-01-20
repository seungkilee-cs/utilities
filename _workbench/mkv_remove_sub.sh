#!/usr/bin/env bash

: '
Name: mkv_remove_sub.sh

Usage: bash mkv_remove_sub.sh -d directory_path

This script iterates over a directory and removes all subtitles from any .mkv files found.
It uses the mkvmerge tool from the mkvtoolnix package.

Options:
-d    Path of the target directory (required)
-h    Print Help Message
'

# Function to print the script usage and exit
print_help() {
    grep '^#' "$0" | cut -c 4-
    exit 0
}

# Parse command line options
while getopts d:h option; do
    case "${option}" in
        d) dir=$OPTARG;;
        h) print_help;;
        *) print_help;;
    esac
done

# Check if directory is specified
if [ -z "$dir" ]; then
    echo "Directory not specified. Use -d option to specify the directory."
    exit 1
fi

# Iterate over .mkv files in the specified directory
for file in "$dir"/*.mkv; do
    echo "Processing $file..."

    # Remove subtitles using mkvmerge
    mkvmerge -o "${file%.*}.raw.mkv" --no-subtitles "$file"
done

echo "All subtitles have been dropped from the .mkv files successfully."