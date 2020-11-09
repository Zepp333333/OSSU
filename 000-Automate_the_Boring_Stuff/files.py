import os

os.path.join('folder', 'folder1', 'folder3', 'file.png' )

helloFile = open('hello.txt')
content = helloFile.readlines()
helloFile.close()

helloFile = open('hello2.txt', 'w')
helloFile.write('Helllo!!!!!!')
helloFile.close()

import shelve
shelfFile = shelve.open('mydata')
shelfFile['cats'] = ['Zophies', 'Poola', ' Simon', 'Fat-tail', 'Cleo']
shelfFile.close()

shelfFile = shelve.open('mydata')
print(shelfFile['cats'])
print(list(shelfFile.keys()))
print(list(shelfFile.values()))
shelfFile.close()
