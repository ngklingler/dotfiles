source $HOME/dotfiles/machine.sh

export PATH="$PATH:$HOME/.cargo/bin:$HOME/.local/bin"
[ -z "$PS1" ] && return # return if not interactive

# https://unix.stackexchange.com/questions/10689/how-can-i-tell-if-im-in-a-tmux-session-from-a-bash-script
# https://unix.stackexchange.com/questions/153102/how-to-start-xterm-with-prompt-at-the-bottom/
if [ -z "$(command -v tmux)" ]; then
    PROMPT_COMMAND='(retval=$?;tput cup "$LINES"; exit $retval)'
    # TODO too many spaces when not a git repo, fix in utils source
    export PS1='$(tmux_pane_status $(pwd) $(echo $HOME) 2> /dev/null) > '
else
    [ -z "${TMUX}" ] && $(create_or_attach_tmux)
    PROMPT_COMMAND='(retval=$?;tput cup "$LINES"; exit $retval) && '
    PROMPT_COMMAND+='tmux set pane-border-format " #(tmux_pane_status #{pane_current_path} $HOME)"'

    export PS1="> "
fi

# aliases
alias cat!="$(which cat)"
alias ls!="$(which ls)"
alias cd!="builtin cd"
[ -z "$(command -v rg)" ] || alias todo='rg TODO'
[ -z "$(command -v lsd)" ] || alias lst='lsd --tree'
# use better version if available
if ! [ -z "$(command -v vim)" ]
then
    if ! [ -z "$(command -v nvim)" ]
    then
        alias vi='nvim'
        EDITOR=nvim
        GIT_EDITOR=nvim
        alias vimdiff='nvim -d'
    else
        alias vi='vim'
        EDITOR=vim
        GIT_EDITOR=vim
    fi
fi
[ -z "$(command -v lsd)" ] || alias ls='lsd'
[ -z "$(command -v bat)" ] || alias cat='bat'
function gitdiff () {
    vimdiff $1 <(git show $2:./$1)
}
# triggers
cd () { builtin cd "$@" && ls; }

bind 'set completion-ignore-case on'
bind 'set show-all-if-unmodified on'
