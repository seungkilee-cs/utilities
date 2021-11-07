"""
Format rename all files of certain extension in a folder in the current alphanumerical order.
New name format: {name} {(year)} {seasonXX}{episodeXX}.file_extension

TODO
1. Take in cmdline arg
2. Specify regex pattern with input
"""

from os import rename
from os import path
from os import listdir

def main():
    # Get current directory
    curr_dir = "./"

    # all files in the directory
    all_files = listdir(curr_dir)

    name = "Hanzawa Naoki"
    year = "2013"
    season="01"
    file_format = ".smi"

    log_orig_file_text = False

    # Filter Nones from comprehended list
    file_name_list = list(filter(None, [str(f) if str(f)[-4:] == file_format else None for f in all_files]))

    # Create a file for original name
    if log_orig_file_text:
        orignial_file_name_list = open("original_file_name_list.txt", "w")

    for idx, file_name in enumerate(file_name_list):
        # test
        # print('Index: {} File: {}'.format(f'{idx+1:02}', file_name))
        
        # Write out the current name
        if log_orig_file_text:
            orignial_file_name_list.write(file_name + '\n')

        # Specify out_dir
        out_dir = name + " (" + year + ") " + "S" + season + "E" + f'{idx+1:02}' + file_format
        src = path.realpath(file_name)
        rename(src, out_dir)

    # Close txt
    if log_orig_file_text:
        orignial_file_name_list.close()

if __name__ == "__main__":
    main()
