#!/usr/bin/env python3
import os
import sys
import urllib.parse

def fix_encoding_issues(directory):
    """
    Traverse through the specified directory and fix encoding issues in text files.

    Args:
        directory (str): The path to the directory.

    """
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith((".txt", ".md")):
                file_path = os.path.join(root, file)

                # Read the file content
                with open(file_path, "r", encoding="utf-8") as f:
                    content = f.read()

                # Fix URL encoding issue
                decoded_content = urllib.parse.unquote(content)

                # Write the fixed content back to the file
                with open(file_path, "w", encoding="utf-8") as f:
                    f.write(decoded_content)

def print_usage():
    """
    Print the usage instructions.
    """
    print("Usage: python3 fix_utf8_encoding.py <directory_path>")
    print("Fixes encoding issues in text files within the specified directory.")

def main():
    """
    The main function that accepts the directory path as a command-line argument.
    """
    # Check if the help flag is provided
    if len(sys.argv) == 2 and (sys.argv[1] == "-h" or sys.argv[1] == "--help"):
        print_usage()
        sys.exit(0)

    # Check if the directory path is provided as a command-line argument
    if len(sys.argv) < 2:
        print("Please provide the directory path as a command-line argument.")
        print_usage()
        sys.exit(1)

    # Retrieve the directory path from the command-line argument
    directory_path = sys.argv[1]

    # Check if the directory exists
    if not os.path.isdir(directory_path):
        print("Invalid directory path.")
        sys.exit(1)

    # Call the function to fix encoding issues in the directory
    fix_encoding_issues(directory_path)

if __name__ == "__main__":
    main()
