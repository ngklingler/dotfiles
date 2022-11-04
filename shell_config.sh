[ -f $HOME/dotfiles/machine.sh ] && . $HOME/dotfiles/machine.sh
[ -f $HOME/.env ] && . $HOME/.env
[ -f $HOME/.asdf/asdf.sh ] && . $HOME/.asdf/asdf.sh

export PATH="$HOME/.local/bin:$PATH"

# Use my custom python prompt if available
if [ -f $HOME/dotfiles/prompt.py ] && [ ! -z "$(command -v python3)" ]; then
    export PS1='`python3 $HOME/dotfiles/prompt.py`'
fi

[ "$(command -v firefox)" ] && alias ff=firefox
if [ "$(command -v code)" ]; then
    export EDITOR=code
    export VISUAL="$EDITOR"
    export GIT_EDITOR="code --wait"
    export PSQL_EDITOR="code --wait"
fi

cd () {
    builtin cd "$@" && ls; # ls after switching directory
}

if ! [ -z "$(command -v fd)" ]; then
    export FIND_COMMAND="fd"
elif ! [ -z "$(command -v fdfind)" ]; then
    export FIND_COMMAND="fdfind"
fi
# what if neither?
export FZF_DEFAULT_COMMAND="${FIND_COMMAND} ."
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--bind 'ctrl-h:change-prompt(~ Files> )+reload(${FZF_DEFAULT_COMMAND} ~)' --bind 'ctrl-g:change-prompt(Git Files> )+reload(${FZF_DEFAULT_COMMAND} `git rev-parse --show-toplevel 2> /dev/null`)' --bind 'ctrl-r:change-prompt(Files>)+reload(${FZF_DEFAULT_COMMAND})' --header 'Ctrl-H: Search from Home Directory / Ctrl-G: Search Git Files / Ctrl-R: Search Current Directory'"
export FZF_ALT_C_COMMAND="${FIND_COMMAND} -t d ."
export FZF_ALT_C_OPTS="--bind 'ctrl-h:change-prompt(~ Directories> )+reload(${FZF_ALT_C_COMMAND} ~)' --bind 'ctrl-g:change-prompt(Git Directories> )+reload(${FZF_ALT_C_COMMAND} `git rev-parse --show-toplevel 2> /dev/null`)' --bind 'ctrl-r:change-prompt(Directories>)+reload(${FZF_ALT_C_COMMAND})' --header 'Ctrl-H: Search from Home Directory / Ctrl-G: Search Git Directories / Ctrl-R: Search Current Directory'"

if [ -n "$BASH_VERSION" ]; then
    bind 'set completion-ignore-case on'
    bind 'set show-all-if-unmodified on'

    # FZF shortcuts on mac
    if [[ "$(uname -s)" = "Darwin" ]]; then
        bind -m emacs-standard '"ç": " \C-b\C-k \C-u`__fzf_cd__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'
        bind -m vi-command '"ç": "\C-z\ec\C-z"'
        bind -m vi-insert '"ç": "\C-z\ec\C-z"'
    fi

    [ "$(command -v direnv)" ] && eval "$(direnv hook bash)"
    [ -f $HOME/.asdf/completions/asdf.bash ] && . $HOME/.asdf/completions/asdf.bash

    HISTSIZE=10000
    HISTCONTROL=erasedups

    [ -f ~/.fzf.bash ] && source ~/.fzf.bash

elif [ -n "$ZSH_VERSION" ]; then
    source $HOME/dotfiles/fzf-tab/fzf-tab.plugin.zsh
    typeset -U PATH path # deduplicate path
    # Completion
    autoload -Uz compinit colors
    compinit -d
    colors

    ## Options section
    setopt prompt_subst
    setopt correct           # Auto correct mistakes
    setopt extendedglob      # Extended globbing. Allows using regular expressions with *
    setopt nocaseglob        # Case insensitive globbing
    setopt rcexpandparam     # Array expension with parameters
    setopt nobeep            # No beep
    setopt histignorealldups # If a new command is a duplicate, remove the older one
    setopt share_history
    setopt hist_ignore_space

    zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
    zstyle ':completion:*' rehash true                              # automatically find new executables in path 
    # Speed up completions
    zstyle ':completion:*' accept-exact '*(N)'
    zstyle ':completion:*' use-cache on
    zstyle ':completion:*' cache-path ~/.zsh/cache
    HISTFILE=~/.zsh_history
    HISTSIZE=10000
    SAVEHIST=10000

    ### Keybindings section
    bindkey -e
    bindkey '^[[7~' beginning-of-line # Home key
    bindkey '^[[H' beginning-of-line # Home key
    if [[ "${terminfo[khome]}" != "" ]]; then
      bindkey "${terminfo[khome]}" beginning-of-line # [Home] - Go to beginning of line
    fi
    bindkey '^[[8~' end-of-line # End key
    bindkey '^[[F' end-of-line # End key
    if [[ "${terminfo[kend]}" != "" ]]; then
      bindkey "${terminfo[kend]}" end-of-line # [End] - Go to end of line
    fi
    bindkey '^[[3~' delete-char # Delete key

    if [ -f ~/.fzf.zsh ]; then
        source ~/.fzf.zsh
        [ "$(uname -s)" = "Darwin" ] && bindkey "ç" fzf-cd-widget
    fi
    [ "$(command -v direnv)" ] && eval "$(direnv hook zsh)"
fi
