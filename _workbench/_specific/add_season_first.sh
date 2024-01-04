#!/usr/bin/env bash

############################################################################
# Too Specific
# 이 스크립트는 지정된 디렉토리 내의 모든 파일 이름에서 "S01" 문자열 앞에 공백을 추가합니다.
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
    # 파일 이름에서 "S01" 문자열 앞에 공백을 추가합니다.
    new_name=$(basename -- "$file" | sed 's/S01/ S01/g')
    # 파일 이름을 변경합니다.
    mv -- "$file" "$target_directory/${new_name}"
done