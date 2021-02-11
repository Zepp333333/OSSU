#! /Users/Sergey/opt/anaconda3/bin/python

import sys
from parser import Parser


def assemble(file_name=False):
    if not file_name:
        if check_num_of_args(sys.argv):
            file_name = sys.argv[1]
            raw_input = read_file(file_name)
        else:
            raise Exception('Incorrect number of arguments')
    else:
        raw_input = read_file(file_name)

    p = Parser(raw_input)
    write_file(file_name.split('.')[0] + ".hack", p.__str__())


def check_num_of_args(args):
    return True if len(args) == 2 else False


def read_file(file_name):
    with open(file_name) as file:
        return file.read()


def write_file(file_name, contents):
    with open(file_name, 'w') as file:
        file.write(contents)
        return

if __name__ == '__main__':
    assemble()
