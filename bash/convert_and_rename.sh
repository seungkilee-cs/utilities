ITER=1
TITLE="잔혹한 관객들"
YEAR="2017"
SEASON="01"
ORIG=".ts"
EXTENSION=".mp4"

for i in *${ORIG}; do
    # Convert to new Extension with FFMPEG
    ffmpeg -i "$i" -codec copy "${i%.*}${EXTENSION}"

    echo "Changing File Name ..."
    # Get index for Naming
    IDX=$(printf "%02d" ${ITER})
    # Save original file name with index
    echo ${i} ${IDX} >> "Original File Names.txt"
    # Create new file name
    NEW="${TITLE} (${YEAR}) S${SEASON}E${IDX}${EXTENSION}"
    # Rename created file
    mv "${i%.*}${EXTENSION}" "${NEW}"
    # Print the new name for sanity check
    echo "New Name: ${NEW}"
    # Increment iter
    let ITER=${ITER}+1
done
