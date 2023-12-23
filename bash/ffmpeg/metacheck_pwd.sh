#!/usr/bin/env bash

# Set directory to current directory
dir=$(pwd)

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