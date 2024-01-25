#!/usr/bin/env bash

while getopts d:e: flag
do
    case "${flag}" in
        d) directory=${OPTARG};;
        e) ext=${OPTARG};;
        *) echo "올바른 플래그를 사용해주세요. -d directory -e extension";
           exit 1 ;;
    esac
done

if [ -z "$directory" ]
then
    echo "디렉토리 경로를 -d 플래그와 함께 제공해 주세요.";
    exit 1
fi

echo $directory
echo $ext

# txt Temp
for file in "$directory"/*.$ext
do
    if [ -f "$file" ]
    then
        outfile="${file%.$ext}.utf8.$ext"
        # 리다이렉션 사용하여 출력을 파일로 저장
        iconv -f CP949 -t UTF-8 "$file" > "$outfile"
        echo "변환 완료: $file -> $outfile"
    fi
done

# # SRT Temp
# for file in "$directory"/*.srt
# do
#     if [ -f "$file" ]
#     then
#         outfile="${file%.srt}.utf8.srt"
#         # 리다이렉션 사용하여 출력을 파일로 저장
#         iconv -f CP949 -t UTF-8 "$file" > "$outfile"
#         echo "변환 완료: $file -> $outfile"
#     fi
# done

# SMI Temp
# for file in "$directory"/*.smi
# do
#     if [ -f "$file" ]
#     then
#         outfile="${file%.smi}.utf8.smi"
#         # 리다이렉션 사용하여 출력을 파일로 저장
#         iconv -f CP949 -t UTF-8 "$file" > "$outfile"
#         echo "변환 완료: $file -> $outfile"
#     fi
# done
