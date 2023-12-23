#!/usr/bin/env bash

# Function to create relative links in README.md
create_relative_links() {
    local dir="$1"
    
    # Traverse through each file/directory in the given directory
    for file in "$dir"/*; do
        local filename="$(basename "$file")"
        local escaped_file="${file// /%20}" # Escape whitespace characters
        
        # Check if the file is a markdown file
        if [ "${filename##*.}" = "md" ]; then
            # Create relative link in README.md with "-"
            echo "- [${filename%.*}]($escaped_file)  " >> "$readme_file"
        fi
        
        # Recursive call for subdirectories
        if [ -d "$file" ]; then
            create_relative_links "$file"
        fi
    done
}

# Set the README.md file path
readme_file="./README.md"

# Check if README.md exists at the root
if [ -f "$readme_file" ]; then
    # Clear the contents of README.md
    echo "" > "$readme_file"
else
    # Create a new README.md at the root
    touch "$readme_file"
fi

# Add Table of Contents heading
echo "# Obsidian Vault" >> "$readme_file"
echo >> "$readme_file"

# Traverse the directory structure and create relative links in README.md
create_relative_links "."

echo "README.md file with relative links has been created/modified."