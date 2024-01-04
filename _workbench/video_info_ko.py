#!/usr/bin/env python3

"""
This script takes a directory path as input and prints information about each media file in the directory.
"""

import argparse
import os
import pathlib
import subprocess

def main():
    # Define and take opts from the user
    parser = argparse.ArgumentParser(description='Process directory path.')
    parser.add_argument('-d', required=True, help='Directory path')
    args = parser.parse_args()

    directory_path = args.d
    video_exts = ["mp4", "mkv", "ts", "avi"]

    # wrong command
    if not directory_path:
        print("올바른 옵션을 지정해주세요. (-d <디렉토리 경로>)")
        exit(1)

    # invalid directory
    if not os.path.isdir(directory_path):
        print("지정한 디렉토리가 존재하지 않습니다: " + directory_path)
        exit(1)

    # iterate, and get video details about the media files in the directory
    for file in pathlib.Path(directory_path).iterdir():
        if file.suffix[1:] in video_exts:
            print("파일 이름: " + file.name)
            print("")

            # file size calculation
            file_size_bytes = file.stat().st_size
            file_size_megabytes = file_size_bytes / 1024 / 1024
            file_size_gigabytes = file_size_megabytes / 1024

            # ffprobe for video stream
            probe_video = subprocess.getoutput('ffprobe -v error -select_streams v:0 -show_entries stream=width,height,r_frame_rate,codec_name -of default=noprint_wrappers=1:nokey=1 ' + str(file))
            vcodec, width, height, r_frame_rate = probe_video.split('\n')
            fps_numerator, fps_denominator = r_frame_rate.split('/')
            fps = float(fps_numerator) / float(fps_denominator)

            # ffprobe for audio stream and grab
            probe_audio = subprocess.getoutput('ffprobe -v error  -select_streams a:0 -show_entries stream=codec_name,sample_rate -of default=noprint_wrappers=1:nokey=1 ' + str(file))
            acodec, asamplerate = probe_audio.split('\n')

            print("파일 크기: {:.2f}MB ({:.2f}GB)".format(file_size_megabytes, file_size_gigabytes))
            print("해상도: {}x{}".format(width, height))
            print("프레임율: {:.2f}".format(fps))
            print("비디오 코덱: " + vcodec)
            print("오디오 코덱: " + acodec)
            print("오디오 샘플 레이트: {} Hz".format(asamplerate))
            print("")

if __name__ == "__main__":
    main()