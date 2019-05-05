export PATH="$PATH:$HOME/.cargo/bin:$HOME/.local/bin"
[ -z "$PS1" ] && return # return if not interactive

export PS1="> "

set -o vi # run bind -P to see keybindings
bind TAB:menu-complete # TAB to cycle through completion options

[ -z "$(command -v rg)" ] || alias todo='rg TODO'
[ -z "$(command -v lsd)" ] || alias ls='lsd'
[ -z "$(command -v bat)" ] || alias cat='bat'
cd () { builtin cd "$@" && ls; } # run ls after cd

[ -z "${TMUX}" ] && $(create_or_attach_tmux) # from github.com/ngklingler/utils
