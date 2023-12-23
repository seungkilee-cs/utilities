#!/usr/bin/env bash

# Function to delete "index.md" files in directories recursively
delete_index_files() {
    local dir="$1"
    
    # Traverse through each file/directory in the given directory
    for file in "$dir"/*; do
        # Check if the file is a directory
        if [ -d "$file" ]; then
            # Recursive call to delete index.md files in subdirectories
            delete_index_files "$file"
        fi
        
        # Check if the file is named "index.md" and delete it
        if [ "$(basename "$file")" = "index.md" ]; then
            rm "$file"
            echo "Deleted: $file"
        fi
    done
}

# Call the function to delete "index.md" files recursively starting from the current directory
delete_index_files "."

echo "Deletion of 'index.md' files completed."