#!/usr/bin/env python3
"""

DOES NOT HANDLE INDENT / LINK Correctly

Obsidian Vault README Generator Script

This script analyzes the directory structure of an Obsidian vault and generates a README file based on that structure.

Usage:
    obsidian-index.py [-h] [--path PATH]

Options:
    -h, --help          Display help message and explain script usage.
    --path PATH     Specify the path to the Obsidian vault.
"""

import os
import argparse
from urllib.parse import quote

DEFAULT_PATH = "~/Documents/Obsidian Vault"  # Enter your desired default path here
EXCLUDE_FOLDERS = [".git", ".makemd", ".obsidian", "_Migrate", "_Tempalte"]  # Folders to exclude from the index

def create_index(directory, base_directory, indent=""):
    index_content = ""

    for file in os.listdir(directory):
        file_path = os.path.join(directory, file)
        if os.path.isdir(file_path):
            if file in EXCLUDE_FOLDERS:
                continue
            index_content += f"{indent}<details>\n"
            index_content += f"{indent}  <summary>📁 {file}</summary>\n"
            sub_directory = os.path.join(directory, file)
            sub_index = create_index(sub_directory, base_directory, indent + "  ")
            index_content += sub_index
            index_content += f"{indent}</details>\n"
        elif file.endswith(".md"):
            file_name = os.path.splitext(file)[0]
            relative_path = os.path.relpath(file_path, start=base_directory)
            encoded_relative_path = quote(relative_path, safe=',?!&=/')
            index_content += f"{indent}- 📄 [{file_name}]({encoded_relative_path})\n"

    return index_content

def create_readme(vault_path):
    root_directory = os.path.abspath(vault_path)

    # Create the root directory if it doesn't exist
    if not os.path.exists(root_directory):
        os.makedirs(root_directory)

    readme_path = os.path.join(root_directory, "README.md")
    with open(readme_path, "w", encoding="utf-8") as readme_file:
        readme_file.write("# Obsidian Notes Index\n\n")
        readme_file.write(create_index(root_directory, root_directory))

    readme_full_path = os.path.abspath(readme_path)
    print("README 파일이 생성되었습니다. 경로: {}".format(readme_full_path))

def main():
    # Command-line argument parsing
    parser = argparse.ArgumentParser(description="Obsidian Vault README Generator Script")
    parser.add_argument("--path", default=DEFAULT_PATH, help="Specify the path to the Obsidian vault.")
    args = parser.parse_args()

    # Check if the provided path is valid
    if not os.path.exists(args.path):
        # Check if the default path is set
        if not os.path.exists(os.path.expanduser(DEFAULT_PATH)):
            print("Please enter a valid path or manually set the default path of your Obsidian vault in the global constant.")
            return
        else:
            target_directory = os.path.expanduser(DEFAULT_PATH)
    else:
        target_directory = args.path

    # README creation
    current_directory = os.getcwd()
    vault_path = os.path.join(current_directory, target_directory)
    create_readme(vault_path)

if __name__ == "__main__":
    main()
