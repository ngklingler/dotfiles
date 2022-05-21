#!/bin/bash
function chkmk () {
    [ -d $1 ] || mkdir -p $(dirname $1)
}

function dload () {
    echo "downloading $1 to $2"
    chkmk $2
    if [ "$(command -v curl)" ]; then
        curl $1 -o $2
    elif [ "$(command -v wget)" ]; then
        wget $1 -O $2
    elif [ "$(command -v python3)" ]; then
        python3 << EOF
import urllib.request as x
with open('$2', 'wb') as f:
    f.write(x.urlopen("$1").read())
EOF
    fi
}


function symlink () {
    dir=$HOME/dotfiles
    backup=$HOME/dotfiles/old_dotfiles
    # TODO this list is duplicated in the install function
    case "$1" in
        "shell_config.sh") files="bashrc bash_profile zshrc";;
        *) files="$1";;
    esac

    for file in $files; do
        if [ -f $HOME/.$file ] || [ -L $HOME/.$file ]; then
            chkmk "$backup/$file"
            cp -a $HOME/.$file $backup/$file
            rm $HOME/.$file
        fi
        chkmk $HOME/.$file
        ln -s $HOME/dotfiles/$1 $HOME/.$file
    done
}

function install () {
    [ -d $HOME/dotfiles/old_dotfiles ] && rm -rf $HOME/dotfiles/old_dotfiles
    # TODO install git, pip, fzf
    files="shell_config.sh ipython/profile_default/startup/fzf.py gitconfig ssh/config"
    for f in $files; do
        symlink $f
    done
    [ -f $HOME/dotfiles/machine.sh ] || touch $HOME/dotfiles/machine.sh
    source $HOME/dotfiles/shell_config.sh
}

install 
