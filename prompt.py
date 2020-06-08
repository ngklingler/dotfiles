import os
import re
import subprocess

class colors:
    black = '\033[30m'
    red = '\033[31m'
    green = '\033[32m'
    yellow = '\033[33m'
    blue = '\033[34m'
    magenta = '\033[35m'
    cyan = '\033[36m'
    white = '\033[37m'
    underline = '\033[4m'
    reset = '\033[0m'


def put(text):
    print(text, end='')


def path(cwd=os.getcwd(), home=os.environ['HOME']):
    cwd = cwd.replace(home, '~').split(os.sep)
    put(colors.green if '~' in cwd else colors.red)
    put(os.sep.join([i[:1] for i in cwd[:-1]] + cwd[-1:]))
    put(colors.reset)


def git():
    status = subprocess.run(
        'git status -s -b --ahead-behind'.split(' '), capture_output=True, text=True
    ).stdout
    if not status:
        return
    branch = status[3 : status.find('...')]
    m = re.match(
        '.*?\[(\w*) (\d*)\].*?', status
    )  # group(1) ahead|behind group(2) commits
    d = {'??': '?', ' M': 'm', 'M ': 'M', 'MM': 'mM', 'A ': 'A'}
    x = {d[i.strip()[:2]] for i in status.splitlines()[1:]}
    put(f' {branch} {m.group(1)} {m.group(2)} {"".join(x)}')


if __name__ == '__main__':
    path()
    git()
    print(' > ')
