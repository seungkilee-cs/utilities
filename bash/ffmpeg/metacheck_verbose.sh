#!/usr/bin/env bash

# Set directory to the first argument passed to the script
dir=$1

# Check if directory is not empty
if [ -z "$dir" ]
then
    echo "Error: No directory provided. Usage: ./script.sh <directory>"
    exit 1
fi

# Loop over each file in the directory
for file in "$dir"/*
do
    # Get the file extension
    extension="${file##*.}"

    # Check if the file is not a shell script
    if [ "$extension" != "sh" ]
    then
        # Use ffprobe to get the metadata
        echo "Metadata for $file:"
        ffprobe -show_format "$file" | grep -E 'title=|artist='
    fi
done