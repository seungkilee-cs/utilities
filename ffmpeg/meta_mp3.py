#!/usr/bin/env python3
"""
이 스크립트는 주어진 디렉토리 내의 오디오 파일들의 메타데이터를 수정합니다.
파일 이름이 '아티스트 - 제목' 형식을 따르고 있을 때, 아티스트와 제목 정보를 메타데이터로 추가합니다.
"""

import os
import shutil
import ffmpeg
import sys

def main(directory: str):
    """
    디렉토리 내의 모든 오디오 파일의 메타데이터를 수정하는 함수입니다.

    Args:
        directory (str): 오디오 파일이 있는 디렉토리의 경로입니다.
    """

    # Loop over each audio file in the directory
    for filename in os.listdir(directory):
        file, extension = os.path.splitext(filename)

        # Check if the file is not a shell script
        if extension != ".sh":
            # Split filename into artist and title using " - " as delimiter
            parts = file.split(" - ")
            if len(parts) == 2:
                artist, title = parts

                # Use ffmpeg to change the metadata and create a new temporary file
                input_file = os.path.join(directory, filename)
                output_file = os.path.join(directory, f"{file}_new{extension}")
                stream = ffmpeg.input(input_file)
                stream = ffmpeg.output(stream, output_file, metadata={'artist': artist, 'title': title})
                ffmpeg.run(stream)

                # Replace the original file with the new file
                shutil.move(output_file, input_file)

if __name__ == "__main__":
    main(sys.argv[1])