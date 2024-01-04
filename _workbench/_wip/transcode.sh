#!/usr/bin/env bash

# 스크립트 사용법을 표시하는 함수
usage() {
    echo "Usage: $0 -d <directory>"
    exit 1
}

# 초를 hh:mm:ss로 변환하는 함수
seconds_to_hms() {
    local t=$1
    local hours=$((t / 3600))
    local minutes=$(( (t % 3600) / 60))
    local seconds=$((t % 60))
    printf "%02d:%02d:%02d\n" $hours $minutes $seconds
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

# 시작 시간
start_time=$(date +%s)

# 파일 카운터
file_count=0

# 디렉토리 내의 모든 .ts 파일을 순회하며 인코딩 실행
for file in "$directory"/*.ts; do
    if [ -f "$file" ]; then
        # 파일 크기를 바이트 단위로 가져옵니다.
        original_size_bytes=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file")
        original_size_mb=$(echo "$original_size_bytes / 1024 / 1024" | bc -l)

        # 변환된 파일의 표적 크기 계산 (35% - 40%)
        target_size_mb=$(echo "$original_size_mb * 0.375" | bc -l)

        # 비디오 길이 가져오기 (초단위)
        duration_seconds=$(ffprobe -v error -select_streams v -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file" | awk '{print int($0)}')

        # 표적 비트레이트 계산 (킬로비트/초)
        target_bitrate_kbps=$(echo "scale=2; $target_size_mb * 8 / $duration_seconds" | bc -l)

        # 파일 이름 변환 (.ts -> .mp4)
        output_file="${file%.ts}.mp4"

        # ffmpeg를 사용하여 파일 인코딩
        ffmpeg -i "$file" -c:v libx264 -b:v "${target_bitrate_kbps}k" -c:a aac -b:a 128k -y "$output_file"

        # 파일 카운터 증가
        ((file_count++))
    fi
done

# 종료 시간
end_time=$(date +%s)

# 경과 시간 계산
elapsed=$((end_time - start_time))

# 결과 출력
echo "Transcoding complete: $file_count files processed."
echo "Elapsed time: $(seconds_to_hms $elapsed)"