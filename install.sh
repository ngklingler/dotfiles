#!/bin/bash

# TODO echo 'source ~/.bashrc' >> ~/.bash_profile

function create_symlinks () {
    dir=$HOME/dotfiles # directory of the git repo containing this file
    backup_dir=$dir/old_dotfiles # backup originals in case something breaks
    files="bashrc tmux.conf config/alacritty/alacritty.yml config/nvim/init.vim"

    [ -d "$backup_dir" ] && rm -rf $backup_dir
    # TODO make this programatic off list
    mkdir -p $backup_dir/config/alacritty
    mkdir -p $backup_dir/config/nvim
    mkdir -p $HOME/.config/alacritty
    mkdir -p $HOME/.config/nvim
    
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
    # TODO install plugins too
    tpm_dir=$HOME/.tmux/plugins/tpm
    git_url='https://github.com/tmux-plugins/tpm'
    [ -d "$tpm_dir" ] || git clone $git_url $tpm_dir
}


function install_vim_config () {
    cd $HOME
    rm -rf $HOME/.vim
    git clone https://github.com/ngklingler/vim.git $HOME/.vim
    cd $HOME/.vim
    git submodule init
    # TODO install pynvim for LSP?
    # Things like submodule update and LSP install are done on update too
}


function check_vim_config () {
    # TODO Should vim install be part of vim files?
    cwd=$(pwd)
    if [ -d "$HOME/.vim" ]
    then
        cd $HOME/.vim
        git pull || install_vim_config
    fi
    cwd=$(pwd)
    if [ -f $HOME/.vimrc ]
    then
        cp -a $HOME/.vimrc $HOME/dotfiles/old_dotfiles/.vimrc
        rm $HOME/.vimrc
    fi
    cd $HOME/.vim
    git submodule update
    bash $HOME/.vim/pack/plugins/start/LanguageClient-neovim/install.sh
    cd $cwd
}

# TODO find work around (python or bash?) in case rust not installed
# TODO BUG issue with utils in different branches
function install_necessary_utils () {
    current_dir=$(pwd)
    git clone https://github.com/ngklingler/utils.git $HOME/utils
    utils='create_or_attach_tmux tmux_pane_status'
    cd $HOME/utils
    # TODO stick to master
    git checkout dev
    for util in $utils; do
        cargo install -f --path $HOME/utils/$util
    done
    cd $current_dir
}

function install () {
    create_symlinks
    install_tpm
    check_vim_config
    install_necessary_utils
}

install
