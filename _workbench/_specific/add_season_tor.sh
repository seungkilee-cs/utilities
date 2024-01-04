#!/usr/bin/env bash

############################################################################
#
# 이 스크립트는 지정된 디렉토리 내의 모든 파일 이름에서 ".E" 문자열을 " S01E"로 바꾸고, 마지막 16자를 제거합니다.
# 사용법: ./script.sh <target_directory>
#
# 인자:
# <target_directory>: 파일 이름을 변경할 파일들이 있는 디렉토리
#
############################################################################


# 목표 디렉토리를 입력으로 받습니다.
target_directory=$1

# 디렉토리 내의 모든 파일을 반복합니다.
for file in "$target_directory"/*; do
    # 파일에서 ".E" 문자열을 찾아 " S01E"로 바꿉니다.
    new_name=$(basename -- "$file" | sed 's/\.E/ S01E/g')

    # 파일 이름에서 확장자를 제거합니다.
    base_name=${new_name%.*}
    extension=${new_name##*.}

    # 파일 이름에서 마지막 16자를 제거합니다.
    base_name=$(echo $base_name | awk '{print substr($0, 1, length($0)-17)}')

    # 새로운 파일 이름을 생성합니다.
    new_name="${base_name}.${extension}"

    # 파일 이름을 변경합니다.
    mv -- "$file" "$target_directory/${new_name}"
done