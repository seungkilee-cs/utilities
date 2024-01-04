#!/usr/bin/env bash

############################################################################
# Functional subset of cleanup_final.sh. Use cleanup_final.sh
#
# 이 스크립트는 지정된 디렉토리 내의 모든 파일 이름에서 사용자가 지정한 문자열을 찾아
# 이를 제거하고, 변화된 파일 수를 출력합니다.
# 사용법: ./script.sh <target_directory> <search_string>
#
# 인자:
# <target_directory>: 파일 이름을 변경할 파일들이 있는 디렉토리
# <search_string>: 파일 이름에서 찾아 제거할 문자열
#
############################################################################

# 디렉토리와 대상 문자열을 입력으로 받습니다.
directory_path=$1
target_string=$2

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