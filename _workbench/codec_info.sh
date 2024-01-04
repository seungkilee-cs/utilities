#!/usr/bin/env bash

############################################################################
#
# 이 스크립트는 특정 디렉토리 내의 비디오 파일들에 대한 정보를 추출합니다.
# 사용법: ./script.sh -d <directory>
#
# 인자:
# -d <directory>: 정보를 추출할 비디오 파일들이 있는 디렉토리
#
# 각 비디오 파일에 대해 다음 정보를 출력합니다:
# - 파일 크기 (MB, GB)
# - 해상도 (폭 x 높이)
# - 비디오 코덱
# - 비디오 비트레이트
# - 비디오 재생 시간
# - 오디오 코덱, 채널 수, 비트레이트
#
# 이 스크립트는 다음 확장자를 가진 파일을 처리합니다: mkv, mp4, avi, ts, webm, mov
#
############################################################################


# 스크립트 사용법을 표시하는 함수
usage() {
    echo "Usage: $0 -d <directory>"
    exit 1
}

# 인자를 파싱하는 부분
while getopts ":d:" opt; do
  case $opt in
    d) directory="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
        usage
    ;;
  esac
done

# 필수 인자가 누락되었는지 확인
if [ -z "$directory" ]; then
    usage
fi

# 바이트를 메가바이트로 변환하는 함수
bytes_to_megabytes() {
    echo "$1 / 1024 / 1024" | bc -l
}

# 바이트를 기가바이트로 변환하는 함수
bytes_to_gigabytes() {
    echo "$1 / 1024 / 1024 / 1024" | bc -l
}

# 초를 hh:mm:ss로 변환하는 함수
seconds_to_hms() {
    local t=$1
    local hours=$((t / 3600))
    local minutes=$(( (t % 3600) / 60))
    local seconds=$((t % 60))
    printf "%02d:%02d:%02d\n" $hours $minutes $seconds
}

# 디렉토리 내의 모든 파일을 순회하며 정보 추출
for file in "$directory"/*; do
    # 파일이 존재하는지 확인
    [ -f "$file" ] || continue

    # 파일 확장자 체크
    extension="${file##*.}"
    case "$extension" in
        mkv|mp4|avi|ts|webm|mov)
            # 파일 크기를 바이트 단위로 가져옵니다.
            filesize_bytes=$(stat -f%z "$file")
            filesize_mb=$(bytes_to_megabytes $filesize_bytes)
            filesize_gb=$(bytes_to_gigabytes $filesize_bytes)

            # 파일 정보 출력을 위한 ffprobe 명령어
            echo "File: $file"
            echo "Size: $(printf "%.2f" $filesize_mb) MB ($(printf "%.2f" $filesize_gb) GB)"

            # 비디오 스트림 정보를 가져옵니다.
            ffprobe_output=$(ffprobe -v error -select_streams v:0 \
                    -show_entries stream=width,height,codec_name,codec_long_name,bit_rate,duration \
                    -of default=noprint_wrappers=1 "$file")

            # 출력 정보를 파싱하여 변수에 저장합니다.
            width=$(echo "$ffprobe_output" | grep 'width=' | cut -d'=' -f2)
            height=$(echo "$ffprobe_output" | grep 'height=' | cut -d'=' -f2)
            vcodec=$(echo "$ffprobe_output" | grep 'codec_name=' | cut -d'=' -f2)
            vcodec_long=$(echo "$ffprobe_output" | grep 'codec_long_name=' | cut -d'=' -f2)
            vbitrate=$(echo "$ffprobe_output" | grep 'bit_rate=' | cut -d'=' -f2)
            duration=$(echo "$ffprobe_output" | grep 'duration=' | cut -d'=' -f2)
            duration_hms=$(seconds_to_hms ${duration%.*}) # 소수점 이하 절삭

            # 정보 출력
            echo "Resolution: $width x $height"
            echo "Video Codec: $vcodec ($vcodec_long)"
            echo "Video Bitrate: $vbitrate"
            echo "Duration: $duration_hms"

            # 오디오 스트림 정보를 가져옵니다.
            ffprobe -v error -select_streams a:0 \
                    -show_entries stream=codec_name,codec_long_name,channels,bit_rate \
                    -of default=noprint_wrappers=1 "$file"

            echo "----------------------------------------"
            ;;
        *)
            # If the file extension is not one we're looking for, skip it
            continue
            ;;
    esac
done