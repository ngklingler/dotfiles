export PATH="$PATH:$HOME/.cargo/bin:$HOME/.local/bin"
[ -z "$PS1" ] && return # return if not interactive

# https://unix.stackexchange.com/questions/10689/how-can-i-tell-if-im-in-a-tmux-session-from-a-bash-script
# https://unix.stackexchange.com/questions/153102/how-to-start-xterm-with-prompt-at-the-bottom/
if type tmux >/dev/null 2>/dev/null; then
    [ -z "${TMUX}" ] && $(create_or_attach_tmux)
    PROMPT_COMMAND='(retval=$?;tput cup "$LINES"; exit $retval) && tmux refresh-client -S'
    export PS1="> "
else
    PROMPT_COMMAND='(retval=$?;tput cup "$LINES"l exit $retval)'
    export PS1='$(tmux_pane_status $(pwd) $(echo $HOME)) > '
fi

set -o vi # run bind -P to see keybindings
bind TAB:menu-complete # TAB to cycle through completion options

# aliases
[ -z "$(command -v rg)" ] || alias todo='rg TODO'
# use better version if available
[ -z "$(command -v lsd)" ] || alias ls='lsd'
[ -z "$(command -v bat)" ] || alias cat='bat'
# triggers
cd () { 
    builtin cd "$@"
    ls 
}

