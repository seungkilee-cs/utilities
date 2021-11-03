from os import path
from os import listdir

def main():

    # Get current directory
    path = "./"

    # all files in the directory
    all_files = listdir(path)

    # Filter Nones from comprehended list
    file_name_list = list(filter(None, [str(f) if str(f)[-4:] == ".mp4" else None for f in all_files]))

    for n, x in enumerate(file_name_list):
        print('Index: {} File: {}'.format(n, x))

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
