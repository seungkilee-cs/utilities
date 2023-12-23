# TODO:
# 1. Change the check from != sh to various audio file types
# 2. Add print out for the file order.
# 3. Add print out for the bitrate & sampling size
# 4. Integrate metacheck.sh so the output is printed once metadata editing is complete
# 5. Add support for title and artist as inputs
# 6. Transcribe to Typescript / Javascript
# 7. Write a GUI in electron
# 8. Make up electron app and compile on windows/mac/linux

#!/usr/bin/env bash

# Set directory to the first argument passed to the script
dir=$1

# Check if directory is not empty
if [ -z "$dir" ]
then
    echo "Error: No directory provided. Usage: ./script.sh <directory>"
    exit 1
fi

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
        artist=$(echo $filename | awk -F" - " '{print $1}')
        title=$(echo $filename | awk -F" - " '{print $2}')

        # Use ffmpeg to change the metadata and create a new temporary file
        ffmpeg -i "$file" -metadata artist="$artist" -metadata title="$title" "${file%.*}_new.${file##*.}"

        # Replace the original file with the new file
        # mv "${file%.*}_new.${file##*.}" "$file"
    fi
done