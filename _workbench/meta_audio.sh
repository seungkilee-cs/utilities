#!/usr/bin/env bash

#####################################################################
# 이 스크립트는 주어진 디렉토리 내의 오디오 파일을 순회하며 메타데이터를 수정합니다.
# 파일 이름에서 아티스트와 타이틀을 추출하고, 앨범 이름을 "Download"로 설정한 후,
# 수정된 메타데이터를 가진 새 파일을 'out' 디렉토리에 생성합니다.
# Use this for updating metadata of audio in a specific naming convention
#
# 사용법:
# bash meta_audio.sh <디렉토리 경로>
#
# 인자:
# <디렉토리 경로> -- 오디오 파일의 메타데이터를 수정할 디렉토리의 경로
#
# 이 스크립트에서 사용된 파일 네이밍 컨벤션은 "아티스트 - 타이틀.확장자" 입니다.
# 
# "아티스트 - 타이틀" : 이 부분은 오디오 파일의 아티스트와 타이틀을 나타냅니다. 아티스트와 타이틀은 " - "으로 구분됩니다.
# "확장자" : 이 부분은 오디오 파일의 확장자를 나타냅니다. 'mp3', 'm4a', 'flac' 등의 확장자를 가진 파일을 처리할 수 있습니다.
# 따라서, 이 스크립트는 "아티스트 - 타이틀.mp3" 또는 "아티스트 - 타이틀.m4a" 등의 형태로 이름이 지정된 오디오 파일을 처리하도록 설계되었습니다.
# 
# 이름: meta_audio
#####################################################################


# Set directory to the first argument passed to the script
dir=$1

# Check if directory is not empty
if [ -z "$dir" ]
then
    echo "Error: No directory provided. Usage: ./script.sh <directory>"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$dir/out"

# Loop over each audio file in the directory
for file in "$dir"/*
do
    # Get the file extension
    extension="${file##*.}"

    # Check if the file is an audio file
    if [ "$extension" == "mp3" ] || [ "$extension" == "m4a" ] || [ "$extension" == "flac" ]
    then
        # Get the base name of the file (without path and extension)
        basename=$(basename "$file")
        filename="${basename%.*}"

        # Split filename into artist and title using " - " as delimiter
        artist=$(echo $filename | awk -F" - " '{print $1}')
        title=$(echo $filename | awk -F" - " '{print $2}')

        # Use ffmpeg to change the metadata (including album name) and create a new file in the 'out' directory
        ffmpeg -i "$file" -metadata artist="$artist" -metadata title="$title" -metadata album="Download" -codec copy "${dir}/out/${filename}.${file##*.}"
    fi
done