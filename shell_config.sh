source $HOME/dotfiles/machine.sh

export PATH="$PATH:$HOME/.cargo/bin:$HOME/.local/bin"

[ -z "$PS1" ] && return # return if not interactive

#aliases
alias df='df -h'           # Human-readable sizes
alias free='free -m'       # Show sizes in MB
# use better version if available
if ! [ -z "$(command -v nvim)" ]; then
    alias vi='nvim'
    export EDITOR=nvim
    alias vimdiff='nvim -d'
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
[ -z "$(command -v lsd)" ] || alias ls='lsd'
gitdiff () {
    vimdiff $1 <(git show $2:./$1)
}
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
