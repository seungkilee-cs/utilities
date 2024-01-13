#!/usr/bin/env python3
"""
This script decodes the filenames of text files in a directory and creates corresponding Markdown files
with the decoded names, while preserving the contents of the original files.

Usage:
    python script.py -d <directory_path>
    python script.py -h

Options:
    -d, --directory <directory_path>   Specify the directory path containing the text files.
    -h, --help                         Show this help message and exit.
"""

import os
import sys
import urllib.parse
import shutil

def decode_filename(encoded_filename):
    decoded_filename = urllib.parse.unquote(encoded_filename)
    return decoded_filename

def convert_txt_to_md(txt_filepath, decoded_filename):
    md_filename = decoded_filename + ".md"
    md_filepath = os.path.join(os.path.dirname(txt_filepath), md_filename)
    shutil.copyfile(txt_filepath, md_filepath)

def process_txt_files(directory):
    txt_files = [file for file in os.listdir(directory) if file.endswith(".txt")]

    for txt_file in txt_files:
        txt_filepath = os.path.join(directory, txt_file)
        decoded_filename = decode_filename(txt_file)
        convert_txt_to_md(txt_filepath, decoded_filename)

if __name__ == "__main__":
    # Check if the help option is passed
    if len(sys.argv) > 1 and sys.argv[1] in ("-h", "--help"):
        print(__doc__)
        sys.exit(0)

    # Check if the directory argument is provided
    if len(sys.argv) < 3 or sys.argv[1] not in ("-d", "--directory"):
        print("Usage: python script.py -d <directory_path>")
        sys.exit(1)

    # Get the directory path from the command-line argument
    directory = sys.argv[2]

    # Check if the directory exists
    if not os.path.isdir(directory):
        print("Invalid directory path.")
        sys.exit(1)

    process_txt_files(directory)