#!/usr/bin/env bash

# 파일 이름에 문자열을 추가하여 파일 이름을 변경하는 스크립트입니다.

# 사용법:
#   ./rename_files.sh -d <디렉토리> -s <문자열>

# 옵션:
#   -d <디렉토리>: 변경할 파일이 있는 디렉토리 경로를 지정합니다.
#   -s <문자열>: 파일 이름에 추가할 문자열을 지정합니다.

# 예시:
#   ./rename_files.sh -d /path/to/directory -s "_new"

# 주의사항:
#   - 디렉토리를 지정해야 합니다. -d 옵션을 사용하여 디렉토리 경로를 입력해야 합니다.
#   - 변경된 파일 이름은 현재 파일 이름과 .확장자 사이에 지정한 문자열이 추가됩니다.
#   - 이미 변경된 파일 이름인 경우에는 변경하지 않습니다.

# Parse command line arguments
while getopts "d:s:" option; do
  case $option in
    d) directory=$OPTARG ;;
    s) suffix=$OPTARG ;;
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
    new_name="${file_name_without_extension}${suffix}.$extension"
    if [ "$file_name" != "$new_name" ]; then
      mv "$file" "$directory/$new_name"
      echo "파일 이름이 변경되었습니다: $file -> $directory/$new_name"
    fi
  fi
done