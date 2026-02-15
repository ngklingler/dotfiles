#!/bin/bash
function chkmk() {
  [ -d $1 ] || mkdir -p $(dirname $1)
}

function symlink() {
  dir=$HOME/dotfiles
  backup=$HOME/dotfiles/old_dotfiles
  # TODO this list is duplicated in the install function
  case "$1" in
  "shell_config.sh") files="bashrc bash_profile zshrc" ;;
  *) files="$1" ;;
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

function install() {
  [ -d $HOME/dotfiles/old_dotfiles ] && rm -rf $HOME/dotfiles/old_dotfiles
  # TODO install git, pip, fzf
  files="shell_config.sh gitconfig ssh/config vimrc config/nvim/lua/plugins/core.lua"
  for f in $files; do
    symlink $f
  done
  source $HOME/dotfiles/shell_config.sh
}

sh ./install_programs.sh

install
