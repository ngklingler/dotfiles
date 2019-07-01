#!/bin/bash
function create_symlinks () {
    dir=$HOME/dotfiles # directory of the git repo containing this file
    backup_dir=$dir/old_dotfiles # backup originals in case something breaks
    files="vimrc bashrc tmux.conf config/alacritty/alacritty.yml config/nvim/init.vim"

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

function install_necessary_utils () {
    git clone https://github.com/ngklingler/utils.git $HOME/utils
    utils='create_or_attach_tmux tmux_pane_status'
    pushd $HOME/utils
    for util in $utils; do
        cargo install -f --path $HOME/utils/$util
    done
    popd
    utils='lsd ripgrep bat'
    for util in $utils; do
        cargo install $util
    done
}

setup_environment () {
    curl -o $HOME/dotfiles/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
    source $HOME/.bashrc
    sh /home/ngklingler/.tmux/plugins/tpm/bindings/install_plugins
}

function install () {
    # check if rust installed, if not install it
    if [ -d "$HOME/.cargo/bin/" ]; then
        command -v cargo || export PATH="$PATH:$HOME/.cargo/bin"
    else
        curl https://sh.rustup.rs -sSf | sh
        export PATH="$PATH:$HOME/.cargo/bin"
    fi
    rustup default stable
    # TODO check (g)cc installed for rust linker

    echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
    create_symlinks
    install_tpm
    install_necessary_utils
    setup_environment
}

install
