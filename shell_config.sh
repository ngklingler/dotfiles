source $HOME/dotfiles/machine.sh

export PATH="$PATH:$HOME/.cargo/bin:$HOME/.local/bin"

[ -z "$PS1" ] && return # return if not interactive

#aliases
alias df='df -h'           # Human-readable sizes
alias free='free -m'       # Show sizes in MB
# use better version if available
if ! [ -z "$NVIM_LISTEN_ADRESS" ]; then
    alias vi='nvr'
    export EDITOR='nvr'
elif ! [ -z "$(command -v nvim)" ]; then
    alias vi='nvim'
    export EDITOR=nvim
elif ! [ -z "$(command -v vim)" ]; then
    alias vi='vim'
    export EDITOR=vim
fi
export GIT_EDITOR="$EDITOR"
export VISUAL="$EDITOR"
if ! [ -z "$(command -v ipython)" ]; then
    # TODO ipython --TerminalInteractiveShell.editing_mode=vi makes ipy use vi mode
    alias py=ipython
elif ! [ -z "$(command -v python3)" ]; then
    alias py=python3
fi

cd () {
    builtin cd "$@" && ls;
    [ -z "$NVIM_LISTEN_ADDRESS" ] || nvr --remote-send "<esc>:cd ${@}<cr>i"
    # TODO what if nvr doesn't exists, handle vim
}

if ! [ -z "$(command -v fd)" ]; then
    export FZF_DEFAULT_COMMAND="fd ."
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd -t d . $HOME"
fi
