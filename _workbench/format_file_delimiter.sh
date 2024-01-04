#!/usr/bin/env bash

############################################################################
#
# 이 스크립트는 지정된 디렉토리 내의 모든 파일 이름에서 특정 문자를 변경합니다.
# 사용법: ./script.sh -d <directory> -m <mode>
#
# 인자:
# -d <directory>: 파일 이름을 변경할 파일들이 있는 디렉토리
# -m <mode>: 변경할 모드 ('space' 또는 'dot')
#
# 이 스크립트는 디렉토리가 유효하고, 모드가 'space' 또는 'dot'인지 확인합니다.
# 'space' 모드에서는 파일 이름의 '-', '_', '.'를 공백으로 변경합니다.
# 'dot' 모드에서는 파일 이름의 공백, '-', '_'를 '.'으로 변경합니다.
# 변경된 파일 수를 출력합니다. 만약 동일한 이름의 파일이 이미 존재한다면, 해당 파일의 이름은 변경하지 않습니다.
#
############################################################################


# 초기 변수 선언
directory=""
mode=""
file_count=0

# 디렉토리와 모드를 입력받습니다.
while getopts d:m: flag; do
    case "${flag}" in
        d) directory=${OPTARG};;
        m) mode=${OPTARG};;
    esac
done

# 유효성 검사
if [[ ! -d "$directory" ]]; then
    echo "Error: Directory does not exist."
    exit 1
fi

if [[ "$mode" != "space" && "$mode" != "dot" ]]; then
    echo "Error: Mode must be 'space' or 'dot'."
    exit 1
fi

# 입력받은 디렉토리로 이동합니다.
cd "$directory" || exit

# 디렉토리 내의 각 파일에 대해 반복합니다.
for file in *; do
    # 파일의 이름과 확장자를 분리합니다.
    filename=$(basename "$file")
    extension="${filename##*.}"
    filename="${filename%.*}"

    # 모드에 따라 파일 이름의 특정 문자를 바꿉니다.
    if [[ "$mode" == "space" ]]; then
        temp_name="${filename//-/ }"
        temp_name="${temp_name//_/ }"
        new_name="${temp_name//./ }"
    else
        temp_name="${filename// /.}"
        temp_name="${temp_name//-/.}"
        new_name="${temp_name//_/.}"
    fi

    new_name="$new_name.$extension"

    if [[ -e $new_name ]]; then
        echo "Error: $new_name already exists."
    else
        echo "Changing file name: $file -> $new_name"
        mv -- "$file" "$new_name"
        ((file_count++))
    fi
done

echo "$file_count files were affected."