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

# nnn config
n () {
    # Block nesting of nnn in subshells
    if [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, export NNN_TMPFILE after the call to nnn
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}
export NNN_USE_EDITOR=1

tmuxex () {
    session=$(tmux display-message -p '#S')
    for dir in *; do
        if [[ -d "$dir" ]]; then
            tmux new-window -n $dir -c "$(pwd)/$dir"
            tmux send-keys -t $session:$dir ls Enter
        fi
    done
}
