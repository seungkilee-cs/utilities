#!/usr/bin/env bash

############################################################################
#
# 이 스크립트는 지정된 디렉토리 내의 모든 파일 이름에서 사용자가 지정한 문자열을 찾아
# 이를 제거하고, 변화된 파일 수를 출력하며, 스크립트 실행 시간을 측정합니다.
# 사용법: ./script.sh -d <target_directory> -s <search_string>
#        또는 ./script.sh <target_directory> <search_string>
#
# 인자:
# -d <target_directory>: 파일 이름을 변경할 파일들이 있는 디렉토리
# -s <search_string>: 파일 이름에서 찾아 제거할 문자열
#
############################################################################

# 시간 측정을 시작합니다.
start_time=$(date +%s)

# 디렉토리와 대상 문자열을 정의합니다.
directory_path=""
target_string=""

# 옵션을 처리합니다.
while getopts d:s: flag
do
    case "${flag}" in
        d) directory_path=${OPTARG};;
        s) target_string=${OPTARG};;
    esac
done

# 옵션을 지정하지 않은 경우, 첫 번째 입력값을 디렉토리로, 두 번째 입력값을 대상 문자열로 설정합니다.
if [ -z "$directory_path" ] && [ -z "$target_string" ]; then
    if [ $# -eq 2 ]; then
        directory_path=$1
        target_string=$2
    else
        echo "디렉토리와 대상 문자열을 지정해주세요."
        exit 1
    fi
fi

# 디렉토리가 존재하지 않는 경우 스크립트를 종료합니다.
if [ ! -d "$directory_path" ]; then
    echo "지정한 디렉토리가 존재하지 않습니다: $directory_path"
    exit 1
fi

# 대상 문자열이 비어있는 경우 스크립트를 종료합니다.
if [ -z "$target_string" ]; then
    echo "대상 문자열이 비어있습니다."
    exit 1
fi

# 변화된 파일 수를 세기 위한 카운터를 초기화합니다.
file_count=0

# 디렉토리 내의 모든 파일을 반복합니다.
for file in "$directory_path"/*; do
    # 파일 이름에서 대상 문자열이 있는지 확인합니다.
    if [[ $(basename -- "$file") == *"$target_string"* ]]; then
        # 변화된 파일 수를 증가시킵니다.
        file_count=$((file_count+1))

        # 파일 이름을 출력합니다.
        echo "변경 전 파일 이름: $(basename -- "$file")"

        # 파일 이름에서 대상 문자열을 제거합니다.
        new_name=$(basename -- "$file" | sed "s/$target_string//g")

        # 파일 이름을 변경합니다.
        mv "$file" "$directory_path/$new_name"

        # 변경된 파일 이름을 출력합니다.
        echo "변경 후 파일 이름: $new_name"
    fi
done

# 총 변화된 파일 수를 출력합니다.
echo "변화된 파일 수: $file_count"

# 스크립트 실행 시간을 출력합니다.
end_time=$(date +%s)
run_time=$((end_time-start_time))
echo "스크립트 실행 시간: $run_time 초"