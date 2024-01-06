#!/usr/bin/env bash

# 옵션을 처리합니다.
while getopts "d:e:" flag
do
    case "${flag}" in
        d) directory=$OPTARG;;
        e) extension=$OPTARG;;
        *) echo "잘못된 옵션입니다. 스크립트를 다시 실행하세요." >&2
            exit 1;;
    esac
done

# 디렉토리가 존재하지 않는 경우 스크립트를 종료합니다.
if [ ! -d "$directory" ]; then
    echo "지정한 디렉토리가 존재하지 않습니다: $directory"
    exit 1
fi

# Clean up the test files in the test directory. Could be a little more modular
rm "$directory"/*."$extension"