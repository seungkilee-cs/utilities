#!/usr/bin/env bash

# 인자 파싱
while getopts d:r:u: flag
do
    case "${flag}" in
        d) directory=${OPTARG};;
        r) reponame=${OPTARG};;
        u) user=${OPTARG};;
    esac
done

# 새 디렉토리 생성
parent_dir="$(dirname "$directory")"
newdir="$parent_dir/_page"

# _page 디렉토리 및 그 내부의 .md 파일이 이미 존재한다면 삭제
if [ -d "$newdir" ]; then
    rm -rf "$newdir"
fi

mkdir -p "$newdir"

# 이전 파일 이름 초기화
prev=""

# index.md 파일 경로
indexfile="$parent_dir/index.md"

# index.md 파일 생성 (또는 기존 내용 삭제)
echo -n > "$indexfile"

# 디렉토리 내의 모든 파일에 대해 반복
for file in "$directory"/*
do
    # 파일명 추출 (확장자 포함)
    filename=$(basename -- "$file")
    base=${filename%.*}
    ext=${filename##*.}

    # 새 .md 파일 생성
    mdfile="$newdir/$base.md"

    # .md 파일에 이미지 링크 추가 후 줄 바꿈 추가
    echo -e "![$base](https://github.com/$user/$reponame/blob/master/$directory/$filename?raw=true)  \n" > "$mdfile"

    # .md 파일 링크를 index.md 파일에 추가
    echo "* [$(basename -- "$mdfile" .md)](./_page/$(basename -- "$mdfile"))" >> "$indexfile"
done

# 모든 .md 파일에 대해 이전 파일과 다음 파일 링크 추가
files=("$newdir"/*.md)
count=${#files[@]}

for ((i=0; i<$count; i++))
do
    mdfile=${files[$i]}

    prevfile=""
    nextfile=""

    if ((i > 0)); then
        prevfile=$(basename -- "${files[$((i-1))]}")
    fi

    if ((i < count-1)); then
        nextfile=$(basename -- "${files[$((i+1))]}")
    fi

    if [[ -n $prevfile ]]; then
        echo -n "[< Previous file]($prevfile) " >> "$mdfile"
    fi

    if [[ -n $nextfile ]]; then
        echo "| [Next file >]($nextfile)" >> "$mdfile"
    fi
done