source shell_config.sh

# TODO curl may not exist, also depends on git
[ -z "$(command -v brew)" ] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

[ -z "$(command -v fd)" ] && brew install fd
[ -z "$(command -v rg)" ] && brew install ripgrep
[ -z "$(command -v pipx)" ] && brew install pipx
[ -z "$(command -v jq)" ] && brew install jq


# brew outputs bash completion file locations, capture and source
# ==> Caveats
# Bash completion has been installed to:
#   /home/linuxbrew/.linuxbrew/etc/bash_completion.d
# https://docs.brew.sh/Shell-Completion

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

git clone https://github.com/Aloxaf/fzf-tab $HOME/dotfiles/fzf-tab/

source shell_config.sh
