"""

Generate original file list
change the name - remove dots 

"""

import os, re,

CLEAN = True

def get_file_names(file_type_list: list[str]) -> None:
    if CLEAN:
        os.system("rm orig_name.txt")
    
    files = os.listdir()
    
    with open("orig_name.txt", "w") as f:
        for file in files:
            extension = os.path.splitext(file)[1]
            if extension in file_type_list:
                f.write(file+"\n")
        f.close()

def rename_file(file_name: str, new_name: str) -> None:
    src = os.path.realpath(file_name)
    os.rename(src, new_name)

def clean_file_names(title: str, year: str, exclude_indices: list[int], remove_pattern: str) -> None:
    with open("orig_name.txt", "r") as f:
        name_list = f.read()
        # remove the last \n
        name_list = name_list.split("\n")[:-1]
        for idx, name in enumerate(name_list):
            if idx not in exclude_indices:
                full_name = os.path.splitext(name)
                file_name = full_name[0]
                to_remove = re.search(remove_pattern, file_name)
                remove_text = to_remove.group(0)
                file_name = file_name.replace(remove_text, "").replace(".", " ")
                year_text = "(" + year + ")" + " "
                # remove last white space 
                file_name = file_name[:len(title)+1] + year_text + file_name[len(title)+1:].strip() + full_name[1]
                rename_file(file_name=name, new_name=file_name)
        f.close()

def main():
    file_type = ".mkv"
    title = "Arcane"
    year = "2021"
    get_file_names(file_type_list=[file_type])
    clean_file_names(title=title, year=year, exclude_indices=[0], remove_pattern="1080p.*")

if __name__ == "__main__":
    main()
