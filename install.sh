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

function install () {
    create_symlinks
    install_tpm
}

install
