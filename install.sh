#!/bin/bash
function symlink () {
    dir=$HOME/dotfiles
    backup=$HOME/dotfiles/old_dotfiles
    case "$1" in
        "shell_config") files="bashrc bash_profile zshrc";;
        "vimrc") files="config/nvim/init.vim vimrc";;
        "config/alacritty/alacritty.yml") files="$1";;
    esac

    for file in $files; do
        mkdir -p $backup/$file
        if [ -f $HOME/.$file ] || [ -L $HOME/.$file ]; then
            cp -a $HOME/.$file $backup/$file
            rm $HOME/.$file
        fi
        ln -s $HOME/dotfiles/$1 $HOME/.$file
    done
}

function install_vim_plug () {
    plug_url='https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    dest="$HOME/.vim/autoload/plug.vim"
    if ! [ -f $dest ]; then
        mkdir -p $HOME/.vim/autoload/
        if [ "$(command -v curl)" ]; then
            curl $plug_url -o $dest
        elif [ "$(command -v wget)" ]; then
            wget $plug_url -O $dest
        fi
    fi
}

function install () {
    [ -d $HOME/dotfiles/old_dotfiles ] && rm -rf $HOME/dotfiles/old_dotfiles
    # TODO install git, pip, fzf
    [ -z "$(command -v nvr)" ] && python3 -m pip install --user neovim-remote
    symlink "shell_config"
    symlink "vimrc"
    symlink "config/alacritty/alacritty.yml"
    install_vim_plug
    [ -f $HOME/dotfiles/machine.sh ] || touch $HOME/dotfiles/machine.sh
}

install
