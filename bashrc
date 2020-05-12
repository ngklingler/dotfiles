source $HOME/dotfiles/shell_config.sh

bind 'set completion-ignore-case on'
bind 'set show-all-if-unmodified on'

if [[ "$(uname -s)" = "Darwin" ]]; then
    bind -m emacs-standard '"ç": " \C-b\C-k \C-u`__fzf_cd__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'
    bind -m vi-command '"ç": "\C-z\ec\C-z"'
    bind -m vi-insert '"ç": "\C-z\ec\C-z"'
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
