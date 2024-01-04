#!/usr/bin/env bash

############################################################################
# 이 스크립트는 디렉토리 경로, 타이틀, 시즌 수를 인자로 받아 해당 디렉토리 내에 시즌 수 만큼의 서브 디렉토리를 생성합니다.
# 각 서브 디렉토리는 타이틀과 시즌 번호를 포함한 이름으로 생성됩니다.
#
# 사용법:
# bash create_season_dir.sh -d <디렉토리 경로> -t <타이틀> -s <시즌 수>
#
# 인자:
# -d -- 디렉토리 경로
# -t -- 타이틀
# -s -- 시즌 수
#
# 이름: create_season_dir
############################################################################


# 디렉토리, 타이틀, 시즌 수를 정의합니다.
directory_path=""
title=""
season_count=""

# 옵션을 처리합니다.
while getopts d:t:s: flag
do
    case "${flag}" in
        d) directory_path=${OPTARG};;
        t) title=${OPTARG};;
        s) season_count=${OPTARG};;
    esac
done

# 옵션을 지정하지 않은 경우, 사용자에게 필요한 정보를 요청합니다.
if [ -z "$directory_path" ] || [ -z "$title" ] || [ -z "$season_count" ]; then
    echo "올바른 옵션을 지정해 주세요. (-d <디렉토리 경로> -t <타이틀> -s <시즌 수>)"
    exit 1
fi

# 디렉토리가 존재하지 않는 경우 스크립트를 종료합니다.
if [ ! -d "$directory_path" ]; then
    echo "지정한 디렉토리가 존재하지 않습니다: $directory_path"
    exit 1
fi

# 시즌 수 만큼 디렉토리를 생성합니다.
for (( i=1; i<$season_count+1; i++ ))
do
   # 시즌 번호를 2자리로 0 패딩합니다.
   padded_season=$(printf "%02d" $i)

   # 디렉토리 이름을 생성합니다.
   dir_name="$title S$padded_season"

   # 디렉토리를 생성합니다.
   mkdir -p "$directory_path/$dir_name"
done

echo "$title S00부터 $title S$(printf "%02d" $((season_count)))까지의 디렉토리가 성공적으로 생성되었습니다."