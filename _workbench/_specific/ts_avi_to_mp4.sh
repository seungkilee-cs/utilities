#!/usr/bin/env bash

############################################################################
#
# 이 스크립트는 지정된 디렉토리 내의 모든 .ts 및 .avi 파일을 .mp4 파일로 변환합니다.
# 변환된 파일들은 원본 디렉토리 내의 _o 폴더에 저장됩니다.
# 사용법: ./script.sh <target_directory>
#
# 인자:
# <target_directory>: 파일을 변환할 파일들이 있는 디렉토리
#
############################################################################

# 목표 디렉토리를 입력으로 받습니다.
target_directory=$1

# 출력 파일을 저장할 디렉토리를 생성합니다.
output_directory="${target_directory}/_o"
mkdir -p "$output_directory"

# 디렉토리 내의 모든 파일을 반복합니다.
for file in "$target_directory"/*; do
    # 파일 확장자를 기반으로 처리합니다.
    case "${file##*.}" in
        ts|avi)
            # 파일 이름에서 확장자를 제거하고 새 확장자를 추가합니다.
            new_name=$(basename -- "$file" | sed 's/\.[^.]*$//').mp4
            # FFmpeg를 사용하여 파일을 변환합니다. 
            ffmpeg -i "$file" -vcodec copy -acodec copy "$output_directory/${new_name}"
            ;;
    esac
done