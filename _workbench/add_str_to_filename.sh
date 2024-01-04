#!/usr/bin/env bash

############################################################################
# General Case for add_season_first.sh, add_season_last.sh
#
# 이 스크립트는 지정된 디렉토리 내의 모든 파일 이름에서 특정 문자열을 찾아
# 그 앞이나 뒤에 지정된 문자열을 추가합니다.
# 사용법: ./script.sh -d <target_directory> -s <search_string> -a <add_string> -p <before_after_flag>
#
# 인자:
# -d <target_directory>: 파일 이름을 변경할 파일들이 있는 디렉토리
# -s <search_string>: 파일 이름에서 찾을 문자열
# -a <add_string>: 찾은 문자열 앞이나 뒤에 추가할 문자열
# -p <before_after_flag>: 문자열을 찾은 문자열 앞에 추가할 경우 'before', 뒤에 추가할 경우 'after'
#
############################################################################

while getopts d:s:a:p: opt; do
    case $opt in
        d) target_directory=$OPTARG ;;
        s) search_string=$OPTARG ;;
        a) add_string=$OPTARG ;;
        p) before_after_flag=$OPTARG ;;
    esac
done

for file in "$target_directory"/*; do
    if [[ "$before_after_flag" == "before" ]]; then
        new_name=$(basename -- "$file" | sed "s/$search_string/$add_string$search_string/g")
    elif [[ "$before_after_flag" == "after" ]]; then
        new_name=$(basename -- "$file" | sed "s/$search_string/$search_string$add_string/g")
    fi
    mv -- "$file" "$target_directory/${new_name}"
done