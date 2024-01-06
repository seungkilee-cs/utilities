# For Testing regarding filenames

for i in {1..5}; do touch "_testfiles/[file-$i-1] - This is a gonner.txt"; done
for i in {1..5}; do touch "_testfiles/[file-$i-2] [This Should be gone too].txt"; done
for i in {1..5}; do touch "_testfiles/file-$i-3 This will be removed.txt"; done
for i in {1..5}; do touch "_testfiles/file-$i-4 This will be [removed].txt"; done