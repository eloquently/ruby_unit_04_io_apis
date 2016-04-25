File.read('hello.txt')

File.write('hello2.txt', 'output you want to write to a file')

# 3 modes to open file in:

file = open('hello2.txt', 'w') # write mode overwrites existing content
file = open('hello2.txt', 'r') # read mode is default
file = open('hello2.txt', 'a') # append mode adds content to end of file

file.close