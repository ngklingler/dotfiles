export PATH="$PATH:$HOME/.cargo/bin:$HOME/.local/bin"
[ -z "$PS1" ] && return # return if not interactive

export PS1="> "

[ -z "$(command -v rg)" ] || alias todo='rg TODO'
[ -z "$(command -v lsd)" ] || alias ls='lsd'
[ -z "$(command -v bat)" ] || alias cat='bat'
cd () { builtin cd "$@" && ls; }

[ -z "${TMUX}" ] && $(create_or_attach_tmux) # from github.com/ngklingler/lpm
