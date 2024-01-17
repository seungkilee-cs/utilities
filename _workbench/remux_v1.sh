#!/usr/bin/env bash

: '
Script: ts_to_mp4_converter.sh
Description: This script converts all TS files in a directory to MP4 format without transcoding.
Usage: bash ts_to_mp4_converter.sh -d <directory>
Options:
  -d <directory>   Specify the directory containing TS files for conversion.
  -h               Show this help message and exit.
'

# Function to display the script's help message
display_help() {
  awk -F: '/^: \047/{print substr($0,3)}' "$0"
}

# Parse command line arguments
while getopts "d:h" opt; do
  case $opt in
    d)
      directory=$OPTARG
      ;;
    h)
      display_help
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      display_help
      exit 1
      ;;
  esac
done

# Check if directory is provided
if [ -z "$directory" ]; then
  echo "Directory path is required. Please use the -d option to specify the directory."
  exit 1
fi

# Check if directory exists
if [ ! -d "$directory" ]; then
  echo "Directory does not exist."
  exit 1
fi

# Log file path with current date and execution start time
log_file="$directory/conversion_log_$(date +'%Y%m%d_%H%M%S').txt"

# Loop through each TS file in the directory
for file in "$directory"/*.ts; do
  if [ -f "$file" ]; then
    # Get the base filename without extension
    filename=$(basename "$file" .ts)

    # Construct the output filename with MP4 extension
    output_file="$directory/$filename.mp4"

    # Convert the TS file to MP4 using ffmpeg and redirect output to log file and terminal
    ffmpeg -i "$file" -c copy "$output_file" 2>&1 | tee -a "$log_file"

    echo "Converted $file to $output_file"
  fi
done

echo "Conversion completed."
