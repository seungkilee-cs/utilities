ITER=1
TITLE="TITLE"
YEAR="2021"
SEASON="01"
ORIG=".ts"
EXTENSION=".mp4"

for i in *${ORIG}; do
    ffmpeg -i "$i" -codec copy "${i%.*}${EXTENSION}"
    IDX=$(printf "%02d" ${ITER})
    echo ${i} ${IDX} >> "Original File Names.txt"
    NEW="${TITLE} (${YEAR}) S${SEASON}E${IDX}${EXTENSION}"
    mv "${i%.*}.mp4" "${NEW}"
    echo "New Name: ${NEW}"
    let ITER=${ITER}+1
done
