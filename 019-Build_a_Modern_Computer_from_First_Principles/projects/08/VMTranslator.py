#! /Users/Sergey/opt/anaconda3/bin/python
import re
import sys
import os
from parser import Parser
from codeWriter import CodeWriter


def translate(path=False):
    '''
    Drives the translation process by reading arguments, running routines of reading .vm files
    and orchestrating the parsing and translation/output operations.
    :param path:
    :return:
    '''
    if not path:
        if not sys.argv[1]:
            raise Exception('Path to .vm file or directory containing .vm files is expected')
        path = sys.argv[1]

    input_vm_files, out_file_name = get_in_files(path)
    output = []
    code_writer = CodeWriter()
    for file_name, contents in input_vm_files.items():
        parser = Parser(contents)
        code_writer.set_file_name(file_name)
        while parser.has_more_commands():
            parser.advance()
            code_writer.write(parser.get_current_command())
        output.extend(code_writer.get_output())
    write_file(out_file_name + '.asm', '\n'.join(output))


def get_in_files(path: str) -> tuple:
    """
    Reads vm file or .vm files (if provided path is dir instead of .vm file)
    :param path: path to .vm file or dir containing .vm files to translate
    :return: tuple:
            dict{filename_without_extension: str : file_contents: str},
            output_file_name: str
    """
    input_vm_files = {}
    if not os.path.isdir(path):     # if provided path leads to single file
        if not path.split('.')[-1] == 'vm':
            raise Exception('Provided path {} leads to a non-.vm file'.format(path))
        file_name = os.path.basename(path)
        input_vm_files[file_name] = read_file(path)
        out_file_name = os.path.basename(path).split('.')[0]
    else:                           # if provided path leads to a dir
        files = [path + f for f in os.listdir(path) if re.match(r'.*\.vm', f)]
        if not files:
            raise Exception('Provided directory {} does not contain .vm files.'.format(path))
        input_vm_files = {os.path.basename(f).split('.')[0]: read_file(f) for f in files}
        out_file_name = os.path.dirname(path)
    return input_vm_files, out_file_name


def read_file(path: str):
    with open(path) as file:
        return file.read()


def write_file(path, contents):
    with open(path, 'w') as file:
        file.write(contents)
        return


if __name__ == '__main__':
    translate()
