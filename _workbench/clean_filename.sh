#!/usr/bin/env bash

############################################################################
# 이 스크립트는 주어진 디렉토리 내의 모든 파일과 디렉토리를 순회하며 파일 이름에서 원치 않는 문자열을 제거합니다.
# 여러 사이트의 이름을함하는 파일 이름은 해당 문자열을 삭제합니다.
#
# 사용법:
# bash clean_filename.sh <디렉토리 경로>
#
# 인자:
# <디렉토리 경로> -- 파일 이름을 수정할 디렉토리의 경로
#
# 이름: clean_filename
############################################################################

# Define a function to process files
process_files() {
    local directory="$1"

    # Iterate over all files and directories in the given directory
    for file in "$directory"/*; do
        if [[ -f "$file" ]]; then
            # If it's a file, remove the desired strings from the file name
            new_name="${file//- Pornhub.com}"
            new_name="${new_name//- XVIDEOS.COM/}"
            new_name="${new_name//⋆ Jav Guru ⋆/}"            
            new_name="${new_name//- MissAV.com/}"
            new_name="${new_name// - 무료 HD/}"            
            new_name="${new_name//Japanese porn Tube/}"
            new_name="${new_name// - 7mm.tv - JAV Online/}"
            new_name="${new_name//- 7mmtv.tv - Watch JAV Online/}"
            new_name="${new_name//- 7mmtv.sx - Watch JAV Online/}" 
            new_name="${new_name//- 7mmtv.tv/}"
            new_name="${new_name//- 7mmtv.sx/}" 
            new_name="${new_name//- JAV HD Porn/}"  
            new_name="${new_name// - BestJavPorn/}"
            new_name="${new_name//- JavGG.net/}"  
            new_name="${new_name//Watch /}"
            new_name="${new_name// - on Watch8x.com/}" 
            new_name="${new_name// online - download/}"
            new_name="${new_name//- openload/}"              
            new_name="${new_name//- JAVMOST - Watch Free Jav Online Streaming/}"  
            new_name="${new_name//- Javhd.today/}"
            new_name="${new_name// (rapidvideo.com) Full Porn Video On Pron.tv - HD XXX Search Engine/}"
            new_name="${new_name// - Javhub - online porn streaming for free/}"
            new_name="${new_name// - Supjav.com -/}"
            new_name="${new_name// - JAV Online HPJAV/}"
            new_name="${new_name//(openload.co) Full Porn Video On Pron.tv - HD XXX Search Engine/}"

            new_name="${new_name// ⋆/}"

            
            # Rename the file
            mv "$file" "$new_name"
            # echo "$new_name"
        elif [[ -d "$file" ]]; then
            # If it's a directory, recursively call the function to process files in the subdirectory
            process_files "$file"
        fi

        
    done
}

# Set the current folder as the directory
directory="$(pwd)"

# Call the function to process files starting from the current directory
process_files "$directory"