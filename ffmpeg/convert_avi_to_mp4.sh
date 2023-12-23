for i in *.avi; do
    ffmpeg -i "$i" -codec copy "${i%.*}.mp4"
done