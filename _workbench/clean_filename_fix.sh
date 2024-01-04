#!/usr/bin/env bash

############################################################################
# 이 스크립트는 주어진 디렉토리 내의 모든 파일과 디렉토리를 순회하며 파일 이름을 수정합니다.
# "e.ts"나 "e.mp4"를 포함하는 파일 이름은 해당 문자열을 삭제하고, ".ts"나 ".mp4"를 추가합니다.

# 사용법:
# bash clean_filename_fix.sh <디렉토리 경로>

# 인자:
# <디렉토리 경로> -- 파일 이름을 수정할 디렉토리의 경로

# 이름: clean_filename_fix
############################################################################

# Define a function to process files
process_files() {
    local directory="$1"

    # Iterate over all files and directories in the given directory
    for file in "$directory"/*; do
        if [[ -f "$file" ]]; then
            # Check if the file name contains "e.ts" or "e.mp4"
            if [[ "$file" == *"  e.ts" || "$file" == *"  e.mp4" || "$file" == *" .ts" || "$file" == *" .mp4" ]]; then
                # Remove "e.ts" or "e.mp4" and append ".ts" or ".mp4" respectively
                new_name=$(echo "$file" | sed 's/  e.ts$/.ts/; s/  e.mp4$/.mp4/;s/ .ts$/.ts/; s/ .mp4$/.mp4/;')
                # Rename the file
                mv "$file" "$new_name"
                # echo "$new_name"
            fi
        elif [[ -d "$file" ]]; then
            # If it's a directory, recursively call the function to process files in the subdirectory
            process_files "$file"
        fi
    done
}

# Set the current folder as the directory
directory="$(pwd)"

# Call the function to process files starting from the current directory
process_files "$directory"