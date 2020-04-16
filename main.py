"""
"""
import os
import shutil
import sys

HOME = os.path.expanduser('~')
PATH = sys.path

BASH = [
    "bind 'set completion-ignore-case on'",
    "bind 'set show-all-if-unmodified on'",
    "set -o vi",
]
# TODO zshrc

# $SHELL?
# completion options?
# prompt?
# nnn?


def which(executable):
    if type(executable) != list:
        executable = [executable]
    x = list(
        filter(bool, map(lambda x: shutil.which(x, path=PATH), executable))
    )
    return x[0] if x else None


def attach_tmux():
    tmux = which('tmux')
    if 'TMUX' in os.environ or not tmux:
        return
    with os.popen(
        tmux + " ls -F '#{session_attached}#{session_name}' 2> /dev/null"
    ) as cmd:
        sessions = cmd.read().splitlines()
    for s in sessions:
        if len(s) and s[0] == '0':
            print(f'{tmux} a -t {s[1]}')
            return
    tmux


def set_aliases_and_preferences():
    print("alias df='df -h'")
    print("alias free='free -m'")
    print("alias notes='vi ~/notes'")  # deprecated or used?
    vis = ['nvim', 'vim', 'vi']
    if os.environ.get('NVIM_LISTEN_ADDRESS'):
        vis.insert(0, 'nvr')
    vi = list(filter(bool, map(shutil.which, vis)))[0]
    print(f"alias vi='{vi}'")
    for i in ['EDITOR', 'VISUAL', 'GIT_EDITOR']:
        print(f"export {i}='{vi}'")
    print(f"export MYVIMRC='{HOME}/.vimrc'")
    print(
        'function cd () { builtin cd "$@" && ls; }'
    )  # TODO change to update nvim cwd


# TODO move to global?
def set_path():
    path_add = list(
        filter(
            bool,
            (
                [f'{HOME}/.cargo/bin', f'{HOME}/.local/bin']
                + sys.path
                + os.defpath.split(':')
            ),
        )
    )
    PATH = [
        j
        for i, j in enumerate(path_add)
        if j not in path_add[:i] and os.path.exists(j)
    ]
    print(f'export PATH={":".join(PATH)}')
