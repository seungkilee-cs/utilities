#!/usr/bin/env bash

: '
Usage: ./temp_bleach_rename -d DIRECTORY -s SEASON_NUMBER
Rename .mkv files in the DIRECTORY with the new name format:
[Judas] Bleach - S{season_number}xE{episode_number} - {absolute_order}.mkv

Options:
  -d    Specify the directory containing the .mkv files.
  -s    Specify the season number (will be zero-padded to 2 digits).

Example:
  ./temp_bleach_rename -d /path/to/directory -s 1

Note: This script assumes that the original file names are in the format
[Judas] Bleach - {number}.mkv. If the files have a different format, the script may not work as expected.
'

help_message() {
    echo "
        Usage: ./scriptname -d DIRECTORY -s SEASON_NUMBER
        Rename .mkv files in the DIRECTORY with the new name format:
        [Judas] Bleach - S{season_number}xE{episode_number} - {absolute_order}.mkv
    "
}

# Parse options
while getopts "hd:s:" opt; do
    case "$opt" in
        h) help_message
           exit 0
           ;;
        d) directory=$OPTARG
           ;;
        s) season_number=$(printf "%02d" $OPTARG)
           ;;
        *) help_message
           exit 1
           ;;
    esac
done

# Check if the required options were provided
if [ -z "$directory" ] || [ -z "$season_number" ]; then
    echo "Both directory and season number are required."
    help_message
    exit 1
fi

# Check if the directory exists
if [ ! -d "$directory" ]; then
    echo "The specified directory does not exist: $directory"
    exit 1
fi

cd "$directory"

episode_number=1

# Rename files
for file in *.mkv; do
    if [[ $file =~ ([0-9]+)\.mkv$ ]]; then
        absolute_order=${BASH_REMATCH[1]}
        new_filename="[Judas] Bleach - S${season_number}xE$(printf "%02d" $episode_number) - ${absolute_order}.mkv"
        mv -- "$file" "$new_filename"
        echo "Renamed: $file -> $new_filename"
        ((episode_number++))
    else
        echo "File name does not match the expected format: $file"
    fi
done
