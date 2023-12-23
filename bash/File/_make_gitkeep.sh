#!/usr/bin/env bash

# Function to generate .gitkeep files in directories recursively
generate_gitkeep_files() {
    local dir="$1"
    
    # Traverse through each directory in the given directory
    for directory in "$dir"/*; do
        # Check if the item is a directory
        if [ -d "$directory" ]; then
            # Check if the directory is empty (no files or subdirectories)
            if [ -z "$(ls -A "$directory")" ]; then
                # Check if .gitkeep file already exists
                if [ ! -e "$directory/.gitkeep" ]; then
                    # Create .gitkeep file in the empty directory
                    touch "$directory/.gitkeep"
                    echo "Generated .gitkeep file in: $directory"
                fi
            else
                # Recursive call to generate .gitkeep files in subdirectories
                generate_gitkeep_files "$directory"
            fi
        fi
    done
}

# Call the function to generate .gitkeep files starting from the current directory
generate_gitkeep_files "."

echo "Generation of .gitkeep files completed."