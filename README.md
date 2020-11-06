# Dotfiles
This repository contains my dotfiles for my very custom set up of nvim. I do about all my work in nvim, and use it not only as a text editor but also as a terminal multiplexer. I also have configuration for bash and zsh which I use interchangeably, and alacritty which I commonly use on Windows and Mac, but not often on Linux (using gnome-terminal instead).

In addition I have a custom prompt written in python, a vim cheatsheet for common commands I use, and some snippets.

## Installation
Clone this repository (I recommend to `~/dotfiles`), and run `bash install.sh`. This will:  1. Create an empty directory `~/dotfiles/old_dotfiles`
  2. Check that the command [`nvr`](https://github.com/mhinz/neovim-remote) exists, otherwise install it with `python3 -m pip`
  3. Symlink the following files, copying the existing ones to `~/dotfiles/old_dotfiles`
    a. `~/.bashrc` -> `shell_config.sh`
    b. `~/.bash_profile` -> `shell_config.sh`
    c. `~/.zshrc` -> `shell_config.sh`
    d. `~/.vimrc` -> `vimrc`
    e. `~/.config/alacritty/alacritty.yml` -> `config/alacritty/alacritty.yml`
  4. Download/install [vim-plug](https://github.com/junegunn/vim-plug)
  5. Create a file `~/dotfiles/machine.sh` if it doesn't exist
  6. Source `~/shell_config.sh`
I recommend post installation that you open vim and run `:PlugInstall` to install all plugins.

## shell_config.sh
You may notice that `~/.zshrc` and `~/.bashrc` are both symlinked to `shell_config.sh`. This script has some conditionals to tell if it is being sources by zsh or bash for settings that differ between them, and outside of this all syntax is valid for both shells. The first thing this file does is source `~/dotfiles/machine.sh`, so if you have any machine specific settings (such as changes to $PATH, aliases, environment variables, etc), feel free to put them there. This script does a couple things:
  1. sources `~/dotfiles/machine.sh`
  2. adds `~/.cargo/bin` and `~/.local/bin` to $PATH. This is subject to change.
  3. Returns at this point if not in an interactive session
  4. Sets the prompt to the output of `~/dotfiles/prompt.py` if that file exists
  5. Aliases `vi` to the first matching condition:
    a. `nvr` if running a terminal embedded in a `nvim` instance
    b. `nvim` if it exists
    c. `vim` if it exists
    d. `vi`
  6. Then it sets $EDITOR and $VISUAL to `vi` and sets $GIT_EDITOR to `vi` unless running in an nvim embedded terminal, in which case it is a `nvr` command
  7. aliases `cd` so that `ls` is run when switching directories. When running in an embedded `nvim` terminal, `cd` will also set the `nvim` working directory to whatever directory you just changed to with `cd`
  8. sets [`fzf`](https://github.com/junegunn/fzf) environment variables based off what programs are available
  9. sets sane defaults for completion and case sensitivity, sets a large history
  10. sources `fzf` files if available

## vimrc
