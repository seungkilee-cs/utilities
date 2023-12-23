#!/usr/bin/env bash

print_tree() {
    local directory="$1"
    local level="${2:-0}"
    local prefix=""
    local indent="    "

    for ((i=0; i<level; i++)); do
        prefix="${prefix}${indent}"
    done

    for file in "$directory"/*; do
        if [ -d "$file" ]; then
            echo "${prefix}├─ $(basename "$file")/"
            print_tree "$file" "$((level+1))"
        elif [ -f "$file" ]; then
            echo "${prefix}├─ $(basename "$file")"
        fi
    done
}

echo "$(pwd)/"
print_tree "$(pwd)"