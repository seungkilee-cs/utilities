from os import rename
from os import path
from os import listdir

def main():
    # Get current directory
    curr_dir = "./"

    # all files in the directory
    all_files = listdir(curr_dir)

    # Filter Nones from comprehended list
    file_name_list = list(filter(None, [str(f) if str(f)[-4:] == ".mp4" else None for f in all_files]))

    # Create a file for original name
    orignial_file_name_list = open("original_file_name_list.txt", "w")

    for idx, file_name in enumerate(file_name_list):
        # test
        # print('Index: {} File: {}'.format(f'{idx+1:02}', file_name))
        
        # Write out the current name
        orignial_file_name_list.write(file_name + '\n')

        # Specify out_dir
        out_dir = "DASADA (2021) S01E" + f'{idx+1:02}' + ".mp4"
        src = path.realpath(file_name)
        # Rename
        rename(src, out_dir)

    # Close txt
    orignial_file_name_list.close()

if __name__ == "__main__":
    main()
