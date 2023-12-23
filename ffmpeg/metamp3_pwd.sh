#!/usr/bin/env bash

# Set directory to current directory
dir=$(pwd)

# Loop over each audio file in the directory
for file in "$dir"/*
do
    # Get the file extension
    extension="${file##*.}"

    # Check if the file is not a shell script
    if [ "$extension" != "sh" ]
    then
        # Get the base name of the file (without path and extension)
        basename=$(basename "$file")
        filename="${basename%.*}"

        # Split filename into artist and title using " - " as delimiter
        IFS=' - ' read -r artist title <<< "$filename"

        # Use ffmpeg to change the metadata
        ffmpeg -i "$file" -metadata artist="$artist" -metadata title="$title" "${file%.*}_new.${file##*.}"
    fi
done