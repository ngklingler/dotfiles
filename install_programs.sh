source shell_config.sh

# TODO curl may not exist, also depends on git
[ -z "$(command -v brew)" ] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

[ -z "$(command -v nvim)" ] && brew install neovim
[ -z "$(command -v fd)" ] && brew install fd
[ -z "$(command -v rg)" ] && brew install ripgrep
[ -z "$(command -v pipx)" ] && brew install pipx
[ -z "$(command -v npm)" ] && brew install node
[ -z "$(command -v jq)" ] && brew install jq
[ -z "$(command -v bw)" ] && brew install bitwarden-cli
[ -z "$(command -v fzf)" ] && brew install fzf
# casks don't work on linux
[ -z "$(command -v firefox)" ] && brew install --cask firefox
[ -z "$(command -v spotify)" ] && brew install --cask spotify
[ -z "$(command -v alacritty)" ] && brew install --cask alacritty
[ -z "$(command -v nvr)" ] && pipx install neovim-remote # isn't in path
# brew outputs bash completion file locations, capture and source
# ==> Caveats
# Bash completion has been installed to:
#   /home/linuxbrew/.linuxbrew/etc/bash_completion.d
# https://docs.brew.sh/Shell-Completion

source shell_config.sh
