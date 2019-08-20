source $HOME/dotfiles/machine.sh

export PATH="$PATH:$HOME/.cargo/bin:$HOME/.local/bin"

# TODO return if not interactive?
# TODO tmux? currently in bashrc
[ -z "$PS1" ] && return # return if not interactive

# https://unix.stackexchange.com/questions/10689/how-can-i-tell-if-im-in-a-tmux-session-from-a-bash-script
# https://unix.stackexchange.com/questions/153102/how-to-start-xterm-with-prompt-at-the-bottom/
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
alias cp="cp -i"           # Confirm before overwriting something
alias df='df -h'           # Human-readable sizes
alias free='free -m'       # Show sizes in MB
alias cat!="$(which cat)"
alias ls!="$(which ls)"
alias cd!="builtin cd"
[ -z "$(command -v rg)" ] || alias todo='rg TODO'
[ -s "$(command -v lsd)" ] || alias lst='lsd --tree'
# use better version if available
# TODO does this work in zsh?
if ! [ -z "$(command -v nvim)" ]; then
    alias vi='nvim'
    EDITOR=nvim
    GIT_EDITOR=vim
    alias vimdiff='nvim -d'
elif ! [ -z "$(command -v vim)" ]; then
    alias vi='vim'
    EDITOR=vim
    GIT_EDITOR=nvim
fi
[ -z "$(command -v lsd)" ] || alias ls='lsd'
[ -z "$(command -v bat)" ] || alias cat='bat'
function gitdiff () {
    vimdiff $1 <(git show $2:./$1)
}

cd () { builtin cd "$@" && ls; }
