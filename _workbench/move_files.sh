#!/usr/bin/env bash

# 사용법: ./scriptname.sh -i input_directory -o output_directory -e file_extension

while getopts i:o:e: flag
do
    case "${flag}" in
        i) input_directory=${OPTARG};;
        o) output_directory=${OPTARG};;
        e) file_extension=${OPTARG};;
        *) echo "올바른 플래그를 사용해주세요. -i input_directory -o output_directory -e file_extension";
           exit 1 ;;
    esac
done

if [ -z "$input_directory" ] || [ -z "$output_directory" ] || [ -z "$file_extension" ]
then
    echo "필요한 모든 정보를 제공해 주세요: -i input_directory -o output_directory -e file_extension";
    exit 1
fi

# 입력 디렉토리에서 지정된 확장자를 가진 모든 파일에 대해
for file in "$input_directory"/*."$file_extension"
do
    # 파일이 실제로 존재하는지 확인
    if [ -f "$file" ]
    then
        # 파일을 출력 디렉토리로 이동
        mv "$file" "$output_directory"
        echo "파일 이동: $file -> $output_directory"
    fi
done
