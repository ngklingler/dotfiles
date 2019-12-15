#!/bin/bash
function create_symlinks () {
    # TODO can we check if they are already symlinks to this location?
    dir=$HOME/dotfiles # directory of the git repo containing this file
    backup_dir=$dir/old_dotfiles # backup originals in case something breaks
    files="vimrc bashrc tmux.conf config/alacritty/alacritty.yml config/nvim/init.vim zshrc"

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
    [ -d "$tpm_dir" && cd $tpm_dir && git pull && cd - ] || git clone $git_url $tpm_dir
    sh $HOME/.tmux/plugins/tpm/bindings/install_plugins
}

function install_necessary_utils () {
    git clone https://github.com/ngklingler/utils.git $HOME/utils
    # TODO make above a gitmodule in the dotfiles folder
    utils='create_or_attach_tmux tmux_pane_status'
    for util in $utils; do
        command -v $util || cargo install -f --path $HOME/utils/$util &
    done
    wait
}

function install_brew() {
    if [ "$(uname)" == "Darwin" ]; then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
        test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
        test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
        echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> $HOME/dotfiles/machine.sh
    fi
}

function install_dependencies () {
    if [ -z "$(command -v pacman)" ]; then
        read -p "Use pacman with sudo to install dependencies? [y/n]\n" -n 1 -r
        if [[ $REPLY =~ ^[yY]$ ]]; then
            sudo pacman -Syu
            install='sudo pacman -S'
            command -v pip3 || sudo pacman -S python-pip
        fi
    elif [ ! -z "$(command -v brew)" ]; then
        echo 'Installing dependencies with brew...'
        install='brew install'
        command -v pip3 || brew install python3
    else
        install_brew
        install='brew install'
    fi
    for prog in 'rustup git nvim gcc tmux ripgrep exa alacritty'; do
        command -v $prog || $install prog &
    done
    wait
    pip3 install --user pynvim
    rustup default stable
}

function git_completion () {
    echo 'Not yet implemented...'
}

function install () {
    # touch machine.sh if doesn't exist so bashrc source doesn't complain
    [ -f $HOME/dotfiles/machine.sh ] || touch $HOME/dotfiles/machine.sh
    echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
    install_dependencies
    create_symlinks &
    install_tpm &
    install_necessary_utils
}

install
