import os, sys, re


def get_in_files(path) -> dict:
    input_vms = {}
    if not os.path.isdir(path):
        file_name = os.path.basename(path)
        input_vms[file_name] = read_file(path)
    else:
        files = [path + f for f in os.listdir(path) if re.match(r'.*\.vm', f)]
        input_vms = {os.path.basename(f): read_file(f) for f in files}
    return input_vms


def read_file(file_name):
    with open(file_name) as file:
        return file.read()


def write_file(file_name, contents):
    with open(file_name, 'w') as file:
        file.write(contents)
        return
