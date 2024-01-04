#!/usr/bin/env bash

############################################################################
# Too Specific
# 이 스크립트는 지정된 디렉토리 내의 모든 파일 이름에서 마지막 5개 문자 앞에 "S01E"를 추가합니다.
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
    # 파일 이름의 마지막 5개 문자를 가져옵니다.
    last_five=$(basename -- "$file" | rev | cut -c -5 | rev)
    # 파일 이름의 나머지 부분을 가져옵니다.
    prefix=$(basename -- "$file" | rev | cut -c 6- | rev)
    # "S01E"를 마지막 5개 문자 앞에 추가하고 파일 이름을 변경합니다.
    mv -- "$file" "$target_directory/${prefix}S01E${last_five}"
done