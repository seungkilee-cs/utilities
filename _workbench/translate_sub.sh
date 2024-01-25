#!usr/bin/env bash

: '
This script utilizes SRTranslator from https://github.com/sinedie/SRTranslator. If this is not installed, make sure you install the tool by

pip install srtranslator

Usage: 

./translate_sub.sh -d /path/to/subtitle

bash translate_sub.sh -d /path/to/subtitle

Options:
-d  Path to the target directory (required)
'

# Print the docstring
print_help() {
    echo "$(grep '^: ' "$0" | cut -c3-)"
}

# Flag setting
while getopts d:s:i:o flag
do
    case "${flag}" in
        d) dir=${OPTARG} ;;
        s) sub_type=${OPTARG} ;;
        i) input_lang=${OPTARG} ;;
        o) output_lang=${OPTARG} ;;
        *) print_help; exit;;
    esac
done

# Error handling for invalid input
if [ -z "$dir" ]; then
    echo "Error: The -d option is required."
    print_help
    exit 1
fi

echo $dir
echo $sub_type
echo $input_lang
echo $output_lang

cd "$dir" || exit

# Logic
for subtitle in *.srt; do
    echo $subtitle
    if [ -f "$subtitle" ]; then
        python3 -m srtranslator $subtitle -i en -o ko
    fi
done