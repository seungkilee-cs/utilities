#!/usr/bin/env bash

: '
Script: heic_to_jpg.sh
Description: Converts HEIC files to JPG format using the sips command on macOS.
Usage: ./heic_to_jpg.sh -d <directory>
Options:
  -h: Display usage information.
  -d: Specify the directory path.
'

# Function to display usage information
usage() {
  echo "Usage: ./heic_to_jpg.sh -d <directory>"
  echo "Options:"
  echo "  -h: Display usage information."
  echo "  -d: Specify the directory path."
}

# Check if -h flag is provided
if [ "$1" == "-h" ]; then
  usage
  exit 0
fi

# Check if -d flag and directory are provided
if [ "$1" != "-d" ] || [ -z "$2" ]; then
  echo "Directory path is required. Please use the -d option to specify the directory."
  exit 1
fi

# Check if directory exists
if [ ! -d "$2" ]; then
  echo "Directory does not exist."
  exit 1
fi

# Convert both upper and lower case file extensions (HEIC and heic) to JPG
for file in "$2"/*.HEIC "$2"/*.heic; do
  if [ -f "$file" ]; then
    # Get the base filename without extension
    filename=$(basename "$file" .HEIC)
    filename=$(basename "$filename" .heic)

    # Construct the output filename with JPG extension
    output_file="$2/$filename.jpg"

    # Convert the HEIC file to JPG using sips
    sips -s format jpeg "$file" --out "$output_file"

    echo "Converted $file to $output_file"
  fi
done

echo "Conversion completed."
