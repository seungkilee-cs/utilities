from os import rename
from os import path
from os import listdir

def main():
    # Get current directory
    curr_dir = "./"

    # all files in the directory
    all_files = listdir(curr_dir)

    # Filter Nones from comprehended list
    file_name_list = list(filter(None, [str(f) if str(f)[-4:] == ".mkv" else None for f in all_files]))

    for idx, file_name in enumerate(file_name_list):
        # print('Index: {} File: {}'.format(f'{n+1:02}', x))
        out_dir = "Digimon Adventure꞉ (2020) S01E" + f'{idx+1:02}' + " [1080p].mkv"

        src = path.realpath(file_name)
        # print("src: {} | out: {}".format(src, out_dir))
        rename(src, out_dir)


    # for n in nums:
    #     file_name = "[☆BJ루피☆] 파워디지몬 "+ str(n) + "화 우리말 더빙.mp4"
    #     if n < 10:
    #         new_name = "Digimon Adventure " + "S02E0" + str(n) + ".mp4"
    #     else:
    #         new_name = "Digimon Adventure " + "S02E" + str(n) + ".mp4"
    #     src = path.realpath(file_name)
    #     os.rename(src, new_name)
		
if __name__ == "__main__":
    main()
