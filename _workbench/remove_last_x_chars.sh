#!/usr/bin/env bash

# Docstring
: '
This script removes the last x characters from all file names
in a given directory, excluding the file extension.

Usage:
  ./scriptname.sh -d directory -x count

Flags:
  -d    Directory to process the files
  -x    Number of characters to remove from the end of each file name
'

function print_help {
    echo "
    This script removes the last x characters from all file names
    in a given directory, excluding the file extension.

    Usage:
      ./scriptname.sh -d directory -x count

    Flags:
      -d    Directory to process the files
      -x    Number of characters to remove from the end of each file name
    "
}

while getopts d:x: flag
do
    case "${flag}" in
        d) directory=${OPTARG};;
        x) count=${OPTARG};;
        *) print_help
           exit 1 ;;
    esac
done

if [ -z "$directory" ] || [ -z "$count" ]
then
    print_help
    exit 1
fi

for file in "$directory"/*
do
    if [ -f "$file" ]
    then
        base=$(basename "$file")
        filename=${base%.*}
        ext=${base##*.}
        newfilename=$(echo "$filename" | rev | cut -c $(($count+1))- | rev)
        newfile="$directory/$newfilename.$ext"
        mv "$file" "$newfile"
    fi
done

echo "File renaming completed."
