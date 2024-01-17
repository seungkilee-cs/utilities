#!/usr/bin/env bash

: '
Script Name: remove_characters.sh
Description: This script removes the first X characters from all files within a specified directory.
Usage: remove_characters.sh -d <directory> -x <numchar> [-h]

Options:
  -d <directory>     Specify the directory where the files are located.
  -x <numchar>       Specify the number of characters to remove.
  -h                 Display this help message.

Example Usage:
  remove_characters.sh -d /path/to/directory -x 5
'

while getopts "d:x:h" option; do
  case $option in
    d) directory=$OPTARG ;;
    x) numchar=$OPTARG ;;
    h)
      echo "$(sed -n '/^: \x27/,/^Example Usage:/p' "$0")"
      exit 0
      ;;
    *) echo "잘못된 옵션입니다." ;;
  esac
done

if [[ -z $directory || -z $numchar ]]; then
  echo "디렉토리와 문자 수를 모두 지정해야 합니다."
  exit 1
fi

if [[ ! -d $directory ]]; then
  echo "유효한 디렉토리를 입력해야 합니다."
  exit 1
fi

for file in "$directory"/*; do
  if [[ -f $file ]]; then
    filename=$(basename "$file")
    newfilename="${filename:$numchar}"
    mv "$file" "${directory}/${newfilename}"
  fi
done

echo "모든 파일에서 처음 ${numchar}개의 문자를 제거하는 작업이 완료되었습니다."