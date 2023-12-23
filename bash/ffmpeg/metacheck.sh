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
        title=$(ffprobe -loglevel error -show_entries format_tags=title -of default=noprint_wrappers=1:nokey=1 "$file")
        artist=$(ffprobe -loglevel error -show_entries format_tags=artist -of default=noprint_wrappers=1:nokey=1 "$file")
        
        echo "Metadata for $file:"
        echo "Title: $title"
        echo "Artist: $artist"
        echo ""
    fi
done