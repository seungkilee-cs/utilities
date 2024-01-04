#!/usr/bin/env bash

############################################################################
#
# 이 스크립트는 사용자로부터 입력받은 디렉토리 내의 비디오 파일들에 대한 정보를 출력합니다.
# 출력하는 정보에는 파일 이름, 파일 크기, 해상도, 프레임율, 비디오 코덱, 오디오 코덱, 
# 오디오 샘플 레이트 등이 포함됩니다.
# 이 스크립트는 .mp4, .mkv, .ts, .avi 확장자를 가진 파일들을 처리합니다.
#
# 사용법: 
# ./script_name.sh -d <디렉토리 경로>
#
# 옵션:
# -d <디렉토리 경로>: 정보를 출력할 비디오 파일들이 있는 디렉토리의 경로를 지정합니다.
#
############################################################################

# 사용자로부터 옵션을 입력받습니다.
directory_path=""
video_exts=("mp4" "mkv" "ts" "avi")

while getopts d: flag
do
    case "${flag}" in
        d) directory_path=${OPTARG};;
    esac
done

# 옵션을 잘못 지정한 경우
if [ -z "$directory_path" ]; then
    echo "올바른 옵션을 지정해주세요. (-d <디렉토리 경로>)"
    exit 1
fi

# 지정한 디렉토리가 존재하지 않는 경우
if [ ! -d "$directory_path" ]; then
    echo "지정한 디렉토리가 존재하지 않습니다: $directory_path"
    exit 1
fi

# 디렉토리 내의 모든 파일을 반복하며, 비디오 파일들에 대한 정보를 출력합니다.
for file in "$directory_path"/*; do
    if [[ $file == *.mp4 ]] || [[ $file == *.mkv ]] || [[ $file == *.ts ]] || [[ $file == *.avi ]]; then
        # 파일 이름 출력
        echo "파일 이름: $(basename "$file")"
        echo ""

        # 파일 크기 계산
        file_size_bytes=$(stat -f%z "$file")
        file_size_megabytes=$(echo "scale=2; $file_size_bytes / 1024 / 1024" | bc)
        file_size_gigabytes=$(echo "scale=2; $file_size_megabytes / 1024" | bc)
        
        # 비디오 스트림 정보 추출
        probe_video=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height,r_frame_rate,codec_name -of default=noprint_wrappers=1:nokey=1 "$file")

        # 오디오 스트림 정보 추출
        probe_audio=$(ffprobe -v error  -select_streams a:0 -show_entries stream=codec_name,sample_rate -of default=noprint_wrappers=1:nokey=1 "$file")

        # 추출된 정보 출력
        # ...
    fi
done