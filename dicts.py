import os
import configparser
import sys
import json


def get_ini(f):
    config = configparser.ConfigParser()
    config.read_file(f)
    return {i: {config[i][j] for j in config.options(i)} for i in config.sections()}


def get_git(f):
    result = {}
    for line in f.read().split('\n'):
        if line.startswith('# '):
            split = line.find(' ', 2)
            k1, k2 = line[2:split].split('.')
            value = line[split + 1 :]
            if result.get(k1):
                result[k1].update({k2: value})
            else:
                result[k1] = {k2: value}
        else:
            print('unimplemented')
    return result


def get_json(f):
    json.load(f)


def put_json(d, f):
    json.dump(d, f, indent=2)
    f.write('\n')


def main(infile, outfile):
    # d = get_ini(infile)
    d = get_git(infile)
    put_json(d, outfile)


if __name__ == '__main__':
    main(sys.stdin, sys.stdout)
