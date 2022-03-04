source shell_config.sh

# TODO curl may not exist, also depends on git
[ -z "$(command -v brew)" ] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

[ -z "$(command -v fd)" ] && brew install fd
[ -z "$(command -v rg)" ] && brew install ripgrep
[ -z "$(command -v pipx)" ] && brew install pipx
[ -z "$(command -v jq)" ] && brew install jq
[ -z "$(command -v bw)" ] && brew install bitwarden-cli
[ -z "$(command -v fzf)" ] && brew install fzf
# casks don't work on linux
[ -z "$(command -v firefox)" ] && brew install --cask firefox
[ -z "$(command -v spotify)" ] && brew install --cask spotify

# brew outputs bash completion file locations, capture and source
# ==> Caveats
# Bash completion has been installed to:
#   /home/linuxbrew/.linuxbrew/etc/bash_completion.d
# https://docs.brew.sh/Shell-Completion

code --install-extension 'bastienboutonnet.vscode-dbt'
code --install-extension 'eamodio.gitlens'
code --install-extension 'EditorConfig.EditorConfig'
code --install-extension 'gitkraken.gitkraken-authentication'
code --install-extension 'hashicorp.terraform'
code --install-extension 'innoverio.vscode-dbt-power-user'
code --install-extension 'kj.sqltools-driver-redshift'
code --install-extension 'krnik.vscode-jumpy'
code --install-extension 'ms-azuretools.vscode-docker'
code --install-extension 'ms-python.python'
code --install-extension 'ms-python.vscode-pylance'
code --install-extension 'ms-toolsai.jupyter'
code --install-extension 'ms-toolsai.jupyter-keymap'
code --install-extension 'ms-toolsai.jupyter-renderers'
code --install-extension 'ms-vscode-remote.remote-containers'
code --install-extension 'mtxr.sqltools'
code --install-extension 'mtxr.sqltools-driver-pg'
code --install-extension 'oderwat.indent-rainbow'
code --install-extension 'richie5um2.vscode-sort-json'
code --install-extension 'samuelcolvin.jinjahtml'
code --install-extension 'yzhang.markdown-all-in-one'
code --install-extension 'zhuangtongfa.material-theme'

git clone https://github.com/Aloxaf/fzf-tab $HOME/dotfiles/fzf-tab/

source shell_config.sh
