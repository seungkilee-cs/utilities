#!/usr/bin/env bash

: '
Clean up the name of Pateron files downloaded via Neat Donwload Manager (removing ' _ Patreon' from name)

Should handle .mp3 files

Usage:
-d      directory where the cleanup script would iterate over the files for
'

# Parse options
while getopts d: flag
do
    case "${flag}" in
        d) directory=${OPTARG} ;;
        *) echo "Invalid option. Usage: -d <directory>"; exit 1 ;;
    esac
done

# Check if directory was provided
if [ -z "$directory" ]; then
    echo "Error: Please specify a directory with -d."
    exit 1
fi

# Check if directory exists
if [ ! -d "$directory" ]; then
    echo "Error: Directory does not exist."
    exit 1
fi

# Iterate over .mp3 files and clean up names
echo "Starting cleanup in: $directory"
cd "$directory" || exit

for file in *.mp3; do
    # Skip if no files are matched (to handle case when no .mp3 files are present)
    [ -e "$file" ] || continue
    
    # New file name after removing ' _ Patreon'
    new_name=$(echo "$file" | sed 's/ _ Patreon//')
    
    # Rename the file if new name is different
    if [ "$file" != "$new_name" ]; then
        mv -v "$file" "$new_name"
    fi
done

echo "Cleanup completed."