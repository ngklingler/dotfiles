#!/bin/bash
function chkmk () {
    [ -d $1 ] || mkdir -p $(dirname $1)
}

function dload () {
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
    case "$1" in
        "shell_config.sh") files="bashrc bash_profile zshrc";;
        "vimrc") files="config/nvim/init.vim vimrc";;
        "config/alacritty/alacritty.yml") files="$1";;
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
    [ -z "$(command -v nvr)" ] && python3 -m pip install --user neovim-remote
    files="shell_config.sh vimrc config/alacritty/alacritty.yml"
    for f in $files; do
        symlink $f
    done
    dload 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' "$HOME/.vim/autoload/plug.vim"
    [ -f $HOME/dotfiles/machine.sh ] || touch $HOME/dotfiles/machine.sh
    source $HOME/dotfiles/shell_config.sh
}

install
