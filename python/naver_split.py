"""
Splits videos too large to smaller sizes to upload to naver blog
"""

import sys, subprocess
from moviepy.video.io.ffmpeg_tools import ffmpeg_extract_subclip

def get_duration(file_name: str) -> float:
    # Running subprocess to handle the ffprobe bash
    duration = subprocess.run(["ffprobe", "-v", "error", "-show_entries", "format=duration", "-of","default=noprint_wrappers=1:nokey=1", file_name],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT)
    return float(duration.stdout)

def get_size(file_name: str) -> float:
    size = subprocess.run(["ffprobe", "-v", "error", "-show_entries", "format=size", "-of","default=noprint_wrappers=1:nokey=1", file_name],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT)
    return float(size.stdout)

def convert_second_to_string(seconds: float) -> str:
    hr, min, sec = 0, 0, 0
    if seconds > 3600:
        hr = seconds // 3600
        seconds -= (hr * 3600)
        hr = f'{hr:02}'
    else:
        hr = "00"
    if seconds > 60:
        min = seconds // 60
        seconds -= (min * 60)
        min = f'{min:02}'
    else:
        min = "00"
    sec = f'{seconds:02}'

    return hr + ":" + min + ":" + sec
    

def main(file_name: str):
    uploadable_size = 900000000
    duration, size = get_duration(file_name), get_size(file_name)
    divide = size // uploadable_size
    time, time_table = 0, [0]
    chunks = duration // divide

    while time < duration:
        time += chunks
        time_table.append(round(time))
    
    time_table.pop()
    if time_table[-1] < duration:
        time_table.pop()
        time_table.append(round(duration))
    
    total_split = []

    for t in range(1,len(time_table)):
        new_name = file_name[:-4] + f'{t:02}' + file_name[-4:]
        total_split.append(new_name)
        ffmpeg_extract_subclip(file_name, time_table[t-1], time_table[t], targetname=new_name)

    print("Completed Split!")

        # split_video = subprocess.Popen(
        #     ["ffmpeg", "-i", str(file_name), "-ss", str(time_table[t-1]), "-t", str(time_table[t]), str(new_name)],
        #     stdout=subprocess.PIPE,
        #     stderr=subprocess.PIPE)
        # print("Spliting out " + new_name)
        # child_processes.append(split_video)
        

if __name__ == "__main__":
    file_name = "잔혹한관객들 DVD 특전영상 메이킹 (자막O).mp4"
    main(file_name)
