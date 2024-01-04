#!/usr/bin/env bash

############################################################################
#
# 이 스크립트는 지정된 디렉토리 내의 모든 파일 이름을 주어진 문자 수로 제한합니다.
# 사용법: ./script.sh -d <directory> -c <count>
#
# 인자:
# -d <directory>: 파일 이름을 변경할 파일들이 있는 디렉토리
# -c <count>: 각 파일 이름을 제한할 문자 수
#
# 이 스크립트는 디렉토리가 유효하고, 문자 수가 양의 정수인지 확인합니다.
# 그 후, 각 파일의 이름을 처음 <count> 문자로 제한하고, 변경된 파일 수를 출력합니다.
# 만약 동일한 이름의 파일이 이미 존재한다면, 해당 파일의 이름은 변경하지 않습니다.
#
############################################################################


# 초기 변수 선언
directory=""
count=""
file_count=0

# 디렉토리와 문자 수를 입력받습니다.
while getopts d:c: flag; do
    case "${flag}" in
        d) directory=${OPTARG};;
        c) count=${OPTARG};;
    esac
done

# 유효성 검사
if [[ ! -d "$directory" ]]; then
    echo "Error: Directory does not exist."
    exit 1
fi

if ! [[ "$count" =~ ^[0-9]+$ ]]; then
    echo "Error: Character count must be a positive integer."
    exit 1
fi

# 입력받은 디렉토리로 이동합니다.
cd "$directory" || exit

# 디렉토리 내의 각 파일에 대해 반복합니다.
for file in *; do
    # 파일의 이름과 확장자를 분리합니다.
    filename=$(basename "$file")
    extension="${filename##*.}"
    filename="${filename%.*}"

    # 파일의 이름을 처음 X 문자로 변경하고 확장자를 붙입니다.
    new_name="${filename:0:$count}.$extension"
    if [[ -e $new_name ]]; then
        echo "Error: $new_name already exists."
    else
        echo "Changing file name: $file -> $new_name"
        mv -- "$file" "$new_name"
        ((file_count++))
    fi
done

echo "$file_count files were affected."