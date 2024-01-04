#!/usr/bin/env bash

############################################################################
#
# Get the output name from handbrake (vt_h264, different pixel size, etc)
# and format them into plex appropriate format.
#
############################################################################

# 디렉토리를 정의합니다.
directory_path=""

# 옵션을 처리합니다.
while getopts d: flag
do
    case "${flag}" in
        d) directory_path=${OPTARG};;
    esac
done

# 옵션을 지정하지 않은 경우, 사용자에게 필요한 정보를 요청합니다.
if [ -z "$directory_path" ]; then
    echo "올바른 옵션을 지정해주세요. (-d <디렉토리 경로>)"
    exit 1
fi

# 디렉토리가 존재하지 않는 경우 스크립트를 종료합니다.
if [ ! -d "$directory_path" ]; then
    echo "지정한 디렉토리가 존재하지 않습니다: $directory_path"
    exit 1
fi

# 디렉토리 내의 모든 파일을 반복합니다.
for file in "$directory_path"/*; do
    # 파일이 mp4 또는 mkv 파일인지 확인합니다.
    if [[ $file == *.mp4 ]] || [[ $file == *.mkv ]]; then
        # 파일 이름에서 특정 문자열이 있는지 확인하고, 있으면 변경합니다.
        new_name=$(basename "$file" | sed -e 's/800p/1080p/g' -e 's/808p/1080p/g' -e 's/vt_h264/h264/g' -e 's/vt_h265/hevc/g' -e 's/vt_h265_10bit/hevc_10bit/g')

        # 파일 이름이 변경되었는지 확인하고, 변경되었다면 파일 이름을 변경합니다.
        if [[ $new_name != $(basename "$file") ]]; then
            mv "$file" "$directory_path/$new_name"
        fi
    fi
done