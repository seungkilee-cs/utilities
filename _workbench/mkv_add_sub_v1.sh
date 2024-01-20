#!/usr/bin/env bash

: '
This script adds corresponding SRT subtitles to MKV videos in a specified directory.
The subtitles are set to Korean and named "[Korean] Korean".

Usage: bash add_subtitles.sh -d directory_path

Options:
-d    Path of the target directory (required)
-h    Print Help Message
'

print_help() {
  echo "$(grep '^: ' "$0" | cut -c3-)"
}

while getopts d:h flag
do
    case "${flag}" in
        d) dir=${OPTARG};;  # Set the target directory
        h) print_help; exit;;  # Print the help message and exit
    esac
done

if [ -z "$dir" ]; then
  echo "Error: The -d option is required."
  print_help
  exit 1
fi

cd "$dir" || exit

for mkv_file in *.mkv; do
  base_name=$(basename "$mkv_file" .mkv)
  srt_file="${base_name}.ko.srt"

  if [ -f "$srt_file" ]; then
    echo "Processing file: $mkv_file"
    # Add the new subtitle track and set its language to Korean
    new_file="new_${base_name}.mkv"
    mkvmerge -o "$new_file" --language 0:kor "$mkv_file" "$srt_file"
    echo "Added a new subtitle track to: $new_file"
    
    # Add the name to the new subtitle track
    # Look at
    # ❯ bash mkv_add_sub_v1.sh -d "/Volumes/Media/__TEST/_bench"
    # Processing file: One Piece - 0062.1080p.hevc.mkv
    # mkvmerge v82.0 ('I'm The President') 64-bit
    # 'One Piece - 0062.1080p.hevc.mkv': Using the demultiplexer for the format 'Matroska'.
    # 'One Piece - 0062.1080p.hevc.ko.srt': Using the demultiplexer for the format 'SRT subtitles'.
    # 'One Piece - 0062.1080p.hevc.mkv' track 0: Using the output module for the format 'HEVC/H.265'.
    # 'One Piece - 0062.1080p.hevc.mkv' track 1: Using the output module for the format 'AAC'.
    # 'One Piece - 0062.1080p.hevc.mkv' track 2: Using the output module for the format 'AAC'.
    # 'One Piece - 0062.1080p.hevc.mkv' track 3: Using the output module for the format 'SSA/ASS text subtitles'.
    # 'One Piece - 0062.1080p.hevc.mkv' track 4: Using the output module for the format 'text subtitles'.
    # 'One Piece - 0062.1080p.hevc.mkv' track 5: Using the output module for the format 'text subtitles'.
    # 'One Piece - 0062.1080p.hevc.mkv' track 6: Using the output module for the format 'text subtitles'.
    # 'One Piece - 0062.1080p.hevc.ko.srt' track 0: Using the output module for the format 'text subtitles'.
    # The file 'new_One Piece - 0062.1080p.hevc.mkv' has been opened for writing.
    # The cue entries (the index) are being written...
    # Multiplexing took 3 seconds.
    # Added a new subtitle track to: new_One Piece - 0062.1080p.hevc.mkv
    # The file is being analyzed.
    # Error: No track corresponding to the edit specification 's7' was found. The file has not been modified.
    # Subtitle tracks in new_One Piece - 0062.1080p.hevc.mkv:
    # Track ID 3: subtitles (SubStationAlpha)
    # Track ID 4: subtitles (SubRip/SRT)
    # Track ID 5: subtitles (SubRip/SRT)
    # Track ID 6: subtitles (SubRip/SRT)
    # Track ID 7: subtitles (SubRip/SRT)
    # ❯ bash mkv_add_sub_v1.sh -d "/Volumes/Media/__TEST/_bench"
    # Processing file: One Piece - 0062.1080p.hevc.mkv
    # mkvmerge v82.0 ('I'm The President') 64-bit
    # 'One Piece - 0062.1080p.hevc.mkv': Using the demultiplexer for the format 'Matroska'.
    # 'One Piece - 0062.1080p.hevc.ko.srt': Using the demultiplexer for the format 'SRT subtitles'.
    # 'One Piece - 0062.1080p.hevc.mkv' track 0: Using the output module for the format 'HEVC/H.265'.
    # 'One Piece - 0062.1080p.hevc.mkv' track 1: Using the output module for the format 'AAC'.
    # 'One Piece - 0062.1080p.hevc.mkv' track 2: Using the output module for the format 'AAC'.
    # 'One Piece - 0062.1080p.hevc.mkv' track 3: Using the output module for the format 'SSA/ASS text subtitles'.
    # 'One Piece - 0062.1080p.hevc.mkv' track 4: Using the output module for the format 'text subtitles'.
    # 'One Piece - 0062.1080p.hevc.mkv' track 5: Using the output module for the format 'text subtitles'.
    # 'One Piece - 0062.1080p.hevc.mkv' track 6: Using the output module for the format 'text subtitles'.
    # 'One Piece - 0062.1080p.hevc.ko.srt' track 0: Using the output module for the format 'text subtitles'.
    # The file 'new_One Piece - 0062.1080p.hevc.mkv' has been opened for writing.
    # The cue entries (the index) are being written...
    # Multiplexing took 3 seconds.
    # Added a new subtitle track to: new_One Piece - 0062.1080p.hevc.mkv
    # The file is being analyzed.
    # Error: No track corresponding to the edit specification 's7' was found. The file has not been modified.
    # Subtitle tracks in new_One Piece - 0062.1080p.hevc.mkv:
    # File 'new_One Piece - 0062.1080p.hevc.mkv': container: Matroska
    # Track ID 0: video (HEVC/H.265/MPEG-H)
    # Track ID 1: audio (AAC)
    # Track ID 2: audio (AAC)
    # Track ID 3: subtitles (SubStationAlpha)
    # Track ID 4: subtitles (SubRip/SRT)
    # Track ID 5: subtitles (SubRip/SRT)
    # Track ID 6: subtitles (SubRip/SRT)
    # Track ID 7: subtitles (SubRip/SRT)
    # Attachment ID 1: type 'application/x-truetype-font', size 221328 bytes, file name 'OpenSans-Semibold.ttf'
    # ❯ bash mkv_add_sub_v1.sh -d "/Volumes/Media/__TEST/_bench"
    # Processing file: One Piece - 0062.1080p.hevc.mkv
    # mkvmerge v82.0 ('I'm The President') 64-bit
    # 'One Piece - 0062.1080p.hevc.mkv': Using the demultiplexer for the format 'Matroska'.
    # 'One Piece - 0062.1080p.hevc.ko.srt': Using the demultiplexer for the format 'SRT subtitles'.
    # 'One Piece - 0062.1080p.hevc.mkv' track 0: Using the output module for the format 'HEVC/H.265'.
    # 'One Piece - 0062.1080p.hevc.mkv' track 1: Using the output module for the format 'AAC'.
    # 'One Piece - 0062.1080p.hevc.mkv' track 2: Using the output module for the format 'AAC'.
    # 'One Piece - 0062.1080p.hevc.mkv' track 3: Using the output module for the format 'SSA/ASS text subtitles'.
    # 'One Piece - 0062.1080p.hevc.mkv' track 4: Using the output module for the format 'text subtitles'.
    # 'One Piece - 0062.1080p.hevc.mkv' track 5: Using the output module for the format 'text subtitles'.
    # 'One Piece - 0062.1080p.hevc.mkv' track 6: Using the output module for the format 'text subtitles'.
    # 'One Piece - 0062.1080p.hevc.ko.srt' track 0: Using the output module for the format 'text subtitles'.
    # The file 'new_One Piece - 0062.1080p.hevc.mkv' has been opened for writing.
    # The cue entries (the index) are being written...
    # Multiplexing took 3 seconds.
    # Added a new subtitle track to: new_One Piece - 0062.1080p.hevc.mkv
    # The file is being analyzed.
    # Error: No track corresponding to the edit specification 's7' was found. The file has not been modified.
    # Subtitle tracks in new_One Piece - 0062.1080p.hevc.mkv:
    # + EBML head
    # |+ EBML version: 1
    # |+ EBML read version: 1
    # |+ Maximum EBML ID length: 4
    # |+ Maximum EBML size length: 8
    # |+ Document type: matroska
    # |+ Document type version: 4
    # |+ Document type read version: 2
    # + Segment: size 257422506
    # |+ Seek head (subentries will be skipped)
    # |+ EBML void: size 4012
    # |+ Segment information
    # | + Timestamp scale: 1000000
    # | + Multiplexing application: libebml v1.4.5 + libmatroska v1.7.1
    # | + Writing application: mkvmerge v82.0 ('I'm The President') 64-bit
    # | + Duration: 00:25:01.101000000
    # | + Date: 2024-01-20 10:27:56 UTC
    # | + Segment UID: 0x63 0xd3 0x53 0xb5 0xac 0x9b 0xd8 0x12 0xe5 0x3a 0xa6 0x0c 0x67 0xbd 0x4c 0x41
    # |+ Tracks
    # | + Track
    # |  + Track number: 1 (track ID for mkvmerge & mkvextract: 0)
    # |  + Track UID: 579650918766558911
    # |  + Track type: video
    # |  + "Lacing" flag: 0
    # |  + Language: kor
    # |  + Codec ID: V_MPEGH/ISO/HEVC
    # |  + Codec's private data: size 118 (HEVC profile: Main @L5.1)
    # |  + Default duration: 00:00:00.041708333 (23.976 frames/fields per second for a video track)
    # |  + Language (IETF BCP 47): ko
    # |  + Video track
    # |   + Pixel width: 1920
    # |   + Pixel height: 1080
    # |   + Display width: 1920
    # |   + Display height: 1080
    # | + Track
    # |  + Track number: 2 (track ID for mkvmerge & mkvextract: 1)
    # |  + Track UID: 10906049231854392207
    # |  + Track type: audio
    # |  + Codec ID: A_AAC
    # |  + Codec's private data: size 2
    # |  + Default duration: 00:00:00.021333333 (46.875 frames/fields per second for a video track)
    # |  + Language (IETF BCP 47): en
    # |  + Name: English Stereo
    # |  + Audio track
    # |   + Sampling frequency: 48000
    # |   + Channels: 2
    # | + Track
    # |  + Track number: 3 (track ID for mkvmerge & mkvextract: 2)
    # |  + Track UID: 15959225389526631577
    # |  + Track type: audio
    # |  + "Default track" flag: 0
    # |  + Language: jpn
    # |  + Codec ID: A_AAC
    # |  + Codec's private data: size 2
    # |  + Default duration: 00:00:00.023219954 (43.066 frames/fields per second for a video track)
    # |  + Language (IETF BCP 47): ja
    # |  + Name: Japanese Stereo
    # |  + Audio track
    # |   + Sampling frequency: 44100
    # |   + Channels: 2
    # | + Track
    # |  + Track number: 4 (track ID for mkvmerge & mkvextract: 3)
    # |  + Track UID: 4998522837712241281
    # |  + Track type: subtitles
    # |  + "Default track" flag: 0
    # |  + "Lacing" flag: 0
    # |  + Codec ID: S_TEXT/ASS
    # |  + Codec's private data: size 1579
    # |  + Language (IETF BCP 47): en
    # |  + Name: English
    # | + Track
    # |  + Track number: 5 (track ID for mkvmerge & mkvextract: 4)
    # |  + Track UID: 10806736943176977566
    # |  + Track type: subtitles
    # |  + "Default track" flag: 0
    # |  + "Lacing" flag: 0
    # |  + Language: ara
    # |  + Codec ID: S_TEXT/UTF8
    # |  + Language (IETF BCP 47): ar
    # |  + Name: Arabic
    # | + Track
    # |  + Track number: 6 (track ID for mkvmerge & mkvextract: 5)
    # |  + Track UID: 15944555925214524817
    # |  + Track type: subtitles
    # |  + "Default track" flag: 0
    # |  + "Lacing" flag: 0
    # |  + Language: por
    # |  + Codec ID: S_TEXT/UTF8
    # |  + Language (IETF BCP 47): pt
    # |  + Name: Portuguese (Brazilian)
    # | + Track
    # |  + Track number: 7 (track ID for mkvmerge & mkvextract: 6)
    # |  + Track UID: 1517679325450206866
    # |  + Track type: subtitles
    # |  + "Default track" flag: 0
    # |  + "Lacing" flag: 0
    # |  + Language: spa
    # |  + Codec ID: S_TEXT/UTF8
    # |  + Language (IETF BCP 47): es
    # |  + Name: Spanish (LA)
    # | + Track
    # |  + Track number: 8 (track ID for mkvmerge & mkvextract: 7)
    # |  + Track UID: 14078393698306612043
    # |  + Track type: subtitles
    # |  + "Lacing" flag: 0
    # |  + Language: und
    # |  + Codec ID: S_TEXT/UTF8
    # |  + Language (IETF BCP 47): und
    # |+ EBML void: size 1367
    # |+ Attachments
    # | + Attached
    # |  + File name: OpenSans-Semibold.ttf
    # |  + MIME type: application/x-truetype-font
    # |  + File data: size 221328
    # |  + File UID: 3411372334148791725
    # |+ Cluster
    
    mkvpropedit "$new_file" --edit track:s5 --set name="Korean" --set language=kor
    
    # # Print the subtitle tracks of the new file
    # echo "Subtitle tracks in $new_file:"
    # mkvinfo "$new_file"
  fi
done
