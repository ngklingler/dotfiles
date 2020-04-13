#!/bin/bash

function create_symlinks () {
    # TODO can we check if they are already symlinks to this location?
    dir=$HOME/dotfiles # directory of the git repo containing this file
    backup_dir=$dir/old_dotfiles # backup originals in case something breaks
    files="xonshrc vimrc bashrc tmux.conf config/alacritty/alacritty.yml config/nvim/init.vim zshrc"

    [ -d "$backup_dir" ] && rm -rf $backup_dir
    # TODO make this programatic off list
    mkdir -p $backup_dir/config/alacritty
    mkdir -p $backup_dir/config/nvim
    mkdir -p $HOME/.config/alacritty
    mkdir -p $HOME/.config/nvim

    for file in $files; do
        # if file exists or file exists as symlink then copy and delete
        # use copy so if it is a symlink there will be no problems
        if [ -f $HOME/.$file ] || [ -L $HOME/.$file ]; then
            cp -a $HOME/.$file $backup_dir/$file
            rm $HOME/.$file
        fi
        ln -s $dir/$file $HOME/.$file # create symlink
    done

    if [ -d "$HOME/.vim" ]; then
        cp -r $HOME/.vim $backup_dir/vim
        rm -rf $HOME/.vim
    fi
}

function install_tpm () {
    tpm_dir=$HOME/.tmux/plugins/tpm
    git_url='https://github.com/tmux-plugins/tpm'
    [ -d "$tpm_dir" ] || git clone $git_url $tpm_dir
}

function install () {
    # touch machine.sh if doesn't exist so bashrc source doesn't complain
    [ -f $HOME/dotfiles/machine.sh ] || touch $HOME/dotfiles/machine.sh
    echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
    create_symlinks
    install_tpm
}

install
