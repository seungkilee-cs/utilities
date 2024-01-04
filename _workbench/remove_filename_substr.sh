#!/usr/bin/env bash

############################################################################
#
# 이 스크립트는 지정된 디렉토리 내의 모든 파일 이름에서 사용자가 지정한 문자열을 찾아
# 이를 제거합니다.
# 사용법: ./script.sh -d <target_directory> -s <search_string>
#
# 인자:
# -d <target_directory>: 파일 이름을 변경할 파일들이 있는 디렉토리
# -s <search_string>: 파일 이름에서 찾아 제거할 문자열
#
############################################################################

# Parse command line arguments
while getopts "d:s:" option; do
  case $option in
    d) directory=$OPTARG ;;
    s) substring=$OPTARG ;;
    *) echo "잘못된 옵션입니다. 스크립트를 다시 실행하세요." >&2
       exit 1 ;;
  esac
done

# Check if directory and substring are provided
if [ -z "$directory" ] || [ -z "$substring" ]; then
  echo "디렉토리와 substring을 지정해야 합니다. -d와 -s 옵션을 사용하세요." >&2
  exit 1
fi

# Iterate over files in the directory
for file in "$directory"/*; do
  if [ -f "$file" ]; then
    file_name=$(basename "$file")
    new_name="${file_name/$substring/}"
    if [ "$file_name" != "$new_name" ]; then
      mv "$file" "$directory/$new_name"
      echo "파일 이름이 변경되었습니다: $file -> $directory/$new_name"
    fi
  fi
done