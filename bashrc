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
    PROMPT_COMMAND='(retval=$?;tput cup "$LINES"; exit $retval) && tmux refresh-client -S'
    export PS1="> "
fi

# aliases
alias cat!="$(which cat)"
alias ls!="$(which ls)"
[ -z "$(command -v rg)" ] || alias todo='rg TODO'
[ -z "$(command -v lsd)" ] || alias lst='lsd --tree'
# use better version if available
[ -z "$(command -v vim)" ] || alias vi='vim'
[ -z "$(command -v lsd)" ] || alias ls='lsd'
[ -z "$(command -v bat)" ] || alias cat='bat'
[ -z "$(command -v nvim)" ] || alias vim='nvim'
# triggers
cd () { builtin cd "$@" && ls; }

EDITOR=vi
GIT_EDITOR=vi
set -o vi # run bind -P to see keybindings
bind 'set completion-ignore-case on'
bind 'set show-all-if-unmodified on'
