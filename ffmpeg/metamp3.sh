#!/usr/bin/env bash

# Set directory to the first argument passed to the script
dir=$1

# Check if directory is not empty
if [ -z "$dir" ]
then
    echo "Error: No directory provided. Usage: ./script.sh <directory>"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$dir/out"

# Loop over each audio file in the directory
for file in "$dir"/*
do
    # Get the file extension
    extension="${file##*.}"

    # Check if the file is an audio file
    if [ "$extension" == "mp3" ] || [ "$extension" == "m4a" ] || [ "$extension" == "flac" ]
    then
        # Get the base name of the file (without path and extension)
        basename=$(basename "$file")
        filename="${basename%.*}"

        # Split filename into artist and title using " - " as delimiter
        artist=$(echo $filename | awk -F" - " '{print $1}')
        title=$(echo $filename | awk -F" - " '{print $2}')

        # Use ffmpeg to change the metadata (including album name) and create a new file in the 'out' directory
        ffmpeg -i "$file" -metadata artist="$artist" -metadata title="$title" -metadata album="Download" -codec copy "${dir}/out/${filename}.${file##*.}"
    fi
done