source shell_config.sh

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

[ ! -z "$(command -v wget)" ] && wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -q

# [ ! -z "$(command -v wget)" ] && wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz -q && sudo tar xf nvim-linux-x86_64.tar.gz -C /usr/local/ && sudo ln -sf /usr/local/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim && rm -rf nvim-linux-x86_64.tar.gz

# other things to install: rg, fd/find, pip, pip install neovim-remote

source shell_config.sh
