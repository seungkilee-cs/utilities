from PIL import Image

file_path = r''
convert_option = 'RGB'
out_dir = r''

image1 = Image.open(file_path)
conv1 = image1.convert('RGB')
conv1.save(out_dir)
