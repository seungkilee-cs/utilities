#!/bin/sh                                                                                                                                                     
######################## Transcode the files using ... ########################
# vcodec="mp4v"
# acodec="mp4a"
# vb="1024"
# ab="128"
# mux="mp4"
###############################################################################

# Store path to VLC in $vlc
if command -pv vlc >/dev/null 2>&1; then
    # Linux should find "vlc" when searching PATH
    vlc="vlc"
else
    # macOS seems to need an alias
    vlc="/Applications/Utilities/VLC.app/Contents/MacOS/VLC"
fi
# Sanity check
if ! command -pv "$vlc" >/dev/null 2>&1; then
    printf '%s\n' "Cannot find path to VLC. Abort." >&2
    exit 1
fi

for filename in *; do
    printf '%s\n' "=> Transcoding '$filename'... "
    "$vlc" -I dummy -q "$filename" \
       --sout '#transcode{vcodec="$vcodec",vb="$vb",acodec="$acodec",ab="$ab"}:standard{mux="$mux",dst="$filename.transcoded",access=file}' \
       vlc://quit
    ls -lh "$filename" "$filename.transcoded"
    printf '\n'
done