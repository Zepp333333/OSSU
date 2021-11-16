import shutil
import os
import send2trash

shutil.copy('hello.txt', 'hello_copy.txt')

for folder_name, subfolders, filenames in os.walk('/Users/Sergey/Documents/OneDrive/Coding/OSSU'):
    print('Folder name is ' + folder_name)
    print('Subfolders in ' + folder_name + ' are: ' + str(subfolders))
    print('Files in folder are: ' + str(filenames))
