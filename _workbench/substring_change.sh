#!/usr/bin/env bash

# Parse command line arguments
while getopts "d:s:c:" option; do
  case $option in
    d) directory=$OPTARG ;;
    s) search_string=$OPTARG ;;
    c) change_string=$OPTARG ;;
    *) echo "잘못된 옵션입니다. 스크립트를 다시 실행하세요." >&2
       exit 1 ;;
  esac
done

# Check if directory is provided
if [ -z "$directory" ]; then
  echo "디렉토리를 지정해야 합니다. -d 옵션을 사용하세요." >&2
  exit 1
fi

# Check if search string is provided
if [ -z "$search_string" ]; then
  echo "검색 문자열을 지정해야 합니다. -s 옵션을 사용하세요." >&2
  exit 1
fi

# Check if change string is provided
if [ -z "$change_string" ]; then
  echo "변경할 문자열을 지정해야 합니다. -c 옵션을 사용하세요." >&2
  exit 1
fi

# Change substring of file names in the directory
for file in "$directory"/*; do
  if [ -f "$file" ]; then
    new_name="${file/$search_string/$change_string}"
    if [ "$new_name" != "$file" ]; then
      mv "$file" "$new_name"
      echo "파일 이름이 변경되었습니다: $file -> $new_name"
    fi
  fi
done