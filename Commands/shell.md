# Shell Commands

## Create files

`touch $filename.ext`

for multiple files
```
for i in {1..5}; do touch file$i.txt; done

seq -f "file%.0f.txt" 1 5 | xargs touch
```