source $HOME/dotfiles/machine.sh

export PATH="$PATH:$HOME/.cargo/bin:$HOME/.local/bin"

[ -z "$PS1" ] && return # return if not interactive

if [ -f $HOME/dotfiles/prompt.py ] && [ ! -z "$(command -v python3)" ]; then
    export PS1='`python3 $HOME/dotfiles/prompt.py`'
fi

vi () {
    if [ "$NVIM_LISTEN_ADDRESS" ]; then nvr "$@";
    elif [ "$(command -v nvim)" ]; then nvim "$@";
    elif [ "$(command -v vim)" ]; then vim "$@";
    else vi "$@";
    fi
}
export EDITOR=vi
export VISUAL="$EDITOR"
export GIT_EDITOR="$EDITOR"
[ "$NVIM_LISTEN_ADDRESS" ] && export GIT_EDITOR='nvr -cc split --remote-wait'

cd () {
    builtin cd "$@" && ls;
    [ -z "$NVIM_LISTEN_ADDRESS" ] || nvr --remote-send "<esc>:cd $(pwd)<cr>i"
}

if ! [ -z "$(command -v fd)" ]; then
    export FZF_DEFAULT_COMMAND="fd ."
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd -t d ."
fi


if [ -n "$BASH_VERSION" ]; then
    bind 'set completion-ignore-case on'
    bind 'set show-all-if-unmodified on'

    if [[ "$(uname -s)" = "Darwin" ]]; then
        bind -m emacs-standard '"ç": " \C-b\C-k \C-u`__fzf_cd__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'
        bind -m vi-command '"ç": "\C-z\ec\C-z"'
        bind -m vi-insert '"ç": "\C-z\ec\C-z"'
    fi

    HISTSIZE=10000
    HISTCONTROL=erasedups

    [ -f ~/.fzf.bash ] && source ~/.fzf.bash

elif [ -n "$ZSH_VERSION" ]; then
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
    HISTFILE=~/.zhistory
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
fi
