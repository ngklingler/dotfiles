import os
import re
import subprocess


def put(text):
    print(text, end='')


def path(cwd=os.getcwd(), home=os.path.expanduser('~')):
    cwd = cwd.replace(home, '~').split(os.sep)
    put(os.sep.join([i[:1] for i in cwd[:-1]] + cwd[-1:]))

def first(string, strings):
    return min(
        filter(
            lambda x: x > 0,
            map(
                lambda x: string.find(x),
                strings
            )
        )
    )



# ## <redacted>...origin/<redacted> [ahead 65, behind 6]
def git():
    status = subprocess.run(
        'git status -s -b --ahead-behind'.split(' '), capture_output=True, text=True
    ).stdout
    if not status:
        return
    result = ' ' + status[3 : 4 + first(status[4:], ['...', ' ', '\n'])] # untracked branches don't have ...
    m = re.match(
        '.*?\[[^]*]\].*?', status # diverged: [ahead 65, behind 6]
    )  # group(1) ahead|behind group(2) commits
    if m:
        result += f' {m.group(1)} {m.group(2)}'
    result = result.replace('\n', '')
    put(f'{result} {"*" if status.splitlines()[1:] else ""}')


if __name__ == '__main__':
    path()
    git()
    print(' > ')
