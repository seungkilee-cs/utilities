#!/usr/bin/env python3
import youtube_dl
import argparse
import os

def download_video(url: str, resolution: int, container: str, video_codec: str, destination: str) -> None:
    """
    Download a YouTube video at a specific resolution, container, and video codec.

    Args:
        url (str): The URL of the YouTube video.
        resolution (int): The maximum resolution for the video.
        container (str): The container format for the video.
        video_codec (str): The video codec to be used for the video.
        destination (str): The destination folder for the downloaded files.

    Returns:
        None
    """
    ydl_opts = {
        'format': f'bestvideo[height<={resolution}]+bestaudio/best[height<={resolution}]',
        'outtmpl': os.path.join(destination, '%(title)s.%(ext)s'),
        'merge_output_format': container,
        'video_codec': video_codec,
    }
    with youtube_dl.YoutubeDL(ydl_opts) as ydl:
        ydl.download([url])

def extract_audio(url: str, destination: str) -> None:
    """
    Extract the audio from a YouTube video.

    Args:
        url (str): The URL of the YouTube video.
        destination (str): The destination folder for the downloaded files.

    Returns:
        None
    """
    ydl_opts = {
        'format': 'bestaudio/best',
        'outtmpl': os.path.join(destination, '%(title)s.%(ext)s'),
        'postprocessors': [{
            'key': 'FFmpegExtractAudio',
            'preferredcodec': 'mp3',
            'preferredquality': '192',
        }],
    }
    with youtube_dl.YoutubeDL(ydl_opts) as ydl:
        ydl.download([url])

def download_playlist(playlist_url: str, resolution: int, container: str, video_codec: str, destination: str) -> None:
    """
    Download a YouTube playlist at a specific resolution, container, and video codec.

    Args:
        playlist_url (str): The URL of the YouTube playlist.
        resolution (int): The maximum resolution for the videos in the playlist.
        container (str): The container format for the videos.
        video_codec (str): The video codec to be used for the videos.
        destination (str): The destination folder for the downloaded files.

    Returns:
        None
    """
    ydl_opts = {
        'format': f'bestvideo[height<={resolution}]+bestaudio/best[height<={resolution}]',
        'outtmpl': os.path.join(destination, '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s'),
        'merge_output_format': container,
        'video_codec': video_codec,
    }
    with youtube_dl.YoutubeDL(ydl_opts) as ydl:
        ydl.download([playlist_url])

def print_help() -> None:
    """
    Print detailed instructions on how to use the script.

    Returns:
        None
    """
    print("YouTube Downloader Script")
    print("Usage:")
    print("  python ytdl.py <URL> [--function FUNCTION] [--resolution RESOLUTION] [--container CONTAINER] [--video_codec VIDEO_CODEC] [--destination DESTINATION]")
    print("")
    print("Arguments:")
    print("  URL                      The URL of the YouTube video or playlist")
    print("  --function FUNCTION      The function to perform: video, audio, playlist (default: video)")
    print("  --resolution RESOLUTION  Maximum resolution (default: 720)")
    print("  --container CONTAINER    Container format (default: mp4)")
    print("  --video_codec VIDEO_CODEC Video codec (default: avc1)")
    print("  --destination DESTINATION Destination folder for the downloaded files (default: current directory)")
    print("")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='YouTube Downloader')
    parser.add_argument('url', type=str, help='URL of the YouTube video or playlist')
    parser.add_argument('--function', type=str, default='video', choices=['video', 'audio', 'playlist'], help='Function to perform: video, audio, playlist (default: video)')
    parser.add_argument('--resolution', type=int, default=720, help='Maximum resolution (default: 720)')
    parser.add_argument('--container', type=str, default='mp4', help='Container format (default: mp4)')
    parser.add_argument('--video_codec', type=str, default='avc1', help='Video codec (default: avc1)')
    parser.add_argument('--destination', type=str, default=os.getcwd(), help='Destination folder for the downloaded files (default: current directory)')
    parser.add_argument('-H', '--help-message', action='store_true', help='Print help message')  # Modified option string
    args = parser.parse_args()

    if args.help_message:
        print_help()
    elif args.function == 'playlist' and 'playlist?list=' in args.url:
        download_playlist(args.url, args.resolution, args.container, args.video_codec, args.destination)
    elif args.function == 'audio':
        extract_audio(args.url, args.destination)
    else:
        download_video(args.url, args.resolution, args.container, args.video_codec, args.destination)
