source $HOME/dotfiles/machine.sh

export PATH="$PATH:$HOME/.cargo/bin:$HOME/.local/bin"

[ -z "$PS1" ] && return # return if not interactive

if [ -z "$(command -v tmux)" ]; then
    # TODO too many spaces when not a git repo, fix in utils source
    export PS1='$(tmux_pane_status $(pwd) $(echo $HOME) 2> /dev/null) > '
else
    [ -z "${TMUX}" ] && $(create_or_attach_tmux)
    PROMPT_COMMAND='tmux set pane-border-format " #(tmux_pane_status #{pane_current_path} $HOME)"'
    function precmd() { eval "$PROMPT_COMMAND"; }  # for zsh
    export PS1="> "
fi

#aliases
alias df='df -h'           # Human-readable sizes
alias free='free -m'       # Show sizes in MB
[ -z "$(command -v rg)" ] || alias todo='rg TODO'
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
}
alias notes='vi ~/notes'
