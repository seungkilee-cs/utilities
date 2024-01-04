#!/usr/bin/env python3

"""
This script transcodes `.ts` video files to `.mp4` format using ffmpeg with a target bitrate.
The target bitrate is calculated based on the actual size of the input `.ts` file, aiming to reduce
the file size to approximately 37.5% of the original. The script processes all `.ts` files found
in the specified directory.

Usage:
    python transcode.py <directory>
"""

import subprocess
import os
import sys

def get_file_size(file_path):
    """Returns the file size in bytes."""
    return os.path.getsize(file_path)

def get_duration(file_path):
    """Returns the duration of the video file in seconds."""
    result = subprocess.run(
        ["ffprobe", "-v", "error", "-show_entries",
         "format=duration", "-of", "default=noprint_wrappers=1:nokey=1", file_path],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT
    )
    return float(result.stdout.decode('utf-8').strip())

def transcode_file(file_path, target_bitrate_kbps):
    """Transcodes the file to .mp4 format with the given target bitrate."""
    output_file = f"{os.path.splitext(file_path)[0]}.mp4"
    subprocess.run(
        ["ffmpeg", "-i", file_path, "-c:v", "libx264", "-b:v", f"{target_bitrate_kbps}k",
         "-c:a", "aac", "-b:a", "128k", "-y", output_file]
    )

def main(directory):
    """Processes all `.ts` files in the given directory for transcoding."""
    if not os.path.isdir(directory):
        print("Invalid directory")
        sys.exit(1)

    for file_name in os.listdir(directory):
        if file_name.endswith('.ts'):
            file_path = os.path.join(directory, file_name)
            file_size_mb = get_file_size(file_path) / (1024 * 1024)
            duration = get_duration(file_path)
            target_size_mb = file_size_mb * 0.375
            target_bitrate_kbps = (target_size_mb * 8) / (duration / 60)
            transcode_file(file_path, target_bitrate_kbps)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python transcode.py <directory>")
        sys.exit(1)
    main(sys.argv[1])