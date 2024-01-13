#!/usr/bin/env bash

# Parse command line arguments
while getopts "d:" option; do
  case $option in
    d) directory=$OPTARG ;;
    *) echo "잘못된 옵션입니다. 스크립트를 다시 실행하세요." >&2
       exit 1 ;;
  esac
done

# Check if directory is provided
if [ -z "$directory" ]; then
  echo "디렉토리를 지정해야 합니다. -d 옵션을 사용하세요." >&2
  exit 1
fi

# Iterate over files in the directory
for file in "$directory"/*; do
  if [ -f "$file" ]; then
    file_name=$(basename "$file")
    extension="${file_name##*.}"
    file_name_without_extension="${file_name%.*}"
    new_name="${file_name_without_extension}.1080p.h264.KOR.$extension"
    if [ "$file_name" != "$new_name" ]; then
      mv "$file" "$directory/$new_name"
      echo "파일 이름이 변경되었습니다: $file -> $directory/$new_name"
    fi
  fi
done