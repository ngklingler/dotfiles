#!/bin/bash

function create_symlinks () {
    dir=$HOME/dotfiles # directory of the git repo containing this file
    backup_dir=$HOME/old_dotfiles # backup originals in case something breaks
    files="bashrc tmux.conf" # space separated list of files to symlink

    [ -d "$backup_dir" ] && rm -rf $backup_dir
    mkdir -p $backup_dir
    
    for file in $files; do
        # if file exists or file exists as symlink then copy and delete
        # use copy so if it is a symlink there will be no problems
        if [ -f $HOME/.$file ] || [ -L $HOME/.$file ]
        then
            cp -a $HOME/.$file $backup_dir/$file
            rm $HOME/.$file
        fi
        ln -s $dir/$file $HOME/.$file # create symlink
    done
}

function install_tpm () {
    tpm_dir=$HOME/.tmux/plugins/tpm
    git_url='https://github.com/tmux-plugins/tpm'
    [ -d "$tpm_dir" ] || git clone $git_url $tpm_dir
}

function install_vim_config () {
    vimdir=$HOME/.vim
    [ -d "$vimdir" ] && rm -rf $vimdir
    [ -f $HOME/.vimrc ] && rm $HOME/.vimrc
    git clone --recurse-submodules https://github.com/ngklingler/vim.git $vimdir
}

function install_necessary_utils () {
    git clone https://github.com/ngklingler/utils.git $HOME/utils
    utils='create_or_attach_tmux'
    for util in $utils; do
        cargo install -f --path $HOME/utils/$util
    done
}

function install () {
    create_symlinks
    install_tpm
    install_vim_config
    install_necessary_utils
}

install
