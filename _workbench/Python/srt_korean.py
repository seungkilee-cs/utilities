#!/usr/bin/env python3
"""
This script converts the encoding of all .srt files in a specified directory to 'EUC-KR' encoding.

Usage: python3 convert_to_korean.py -d /path/to/directory

Dependencies: chardet, codecs
"""

import os
import argparse
import chardet
import codecs

def convert_to_korean(input_file, output_file):
    """
    Convert the encoding of a file to 'EUC-KR' encoding.

    Args:
        input_file (str): The path to the input file.
        output_file (str): The path to the output file.

    """
    # Detect the file encoding
    with open(input_file, 'rb') as f:
        rawdata = f.read()
        result = chardet.detect(rawdata)
        file_encoding = result['encoding']

    # Read the file with detected encoding
    with codecs.open(input_file, 'r', encoding=file_encoding) as f:
        content = f.read()

    # Write the content in EUC-KR encoding to a new file
    with codecs.open(output_file, 'w', encoding='euc_kr') as f:
        f.write(content)

def main(directory):
    """
    Convert the encoding of all .srt files in a directory to 'EUC-KR' encoding.

    Args:
        directory (str): The path to the directory.

    """
    # Iterate over the files in the directory
    for filename in os.listdir(directory):
        if filename.endswith('.srt') or filename.endswith('.smi'):
            input_file = os.path.join(directory, filename)
            output_file = os.path.join(directory, 'converted_' + filename)
            convert_to_korean(input_file, output_file)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Convert the encoding of sub files to EUC-KR.')
    parser.add_argument('-d', '--directory', required=True, help='The directory containing .srt files.')
    args = parser.parse_args()
    main(args.directory)
