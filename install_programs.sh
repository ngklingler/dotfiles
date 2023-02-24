source shell_config.sh

# need curl and git
asdf () {
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf
    cd ~/.asdf
    git checkout `git describe --tags --abbrev=0`
    . ./asdf.sh
    cd -
}

direnv () {
    asdf direnv setup --shell bash --version latest
    asdf global direnv latest
}

fd () {
    asdf plugin add fd
    asdf install fd latest
    asdf global fd latest
}

jq () {
    asdf plugin add jq
    asdf install jq latest
    asdf global jq latest
}

asdf
direnv
fd
jq

# TODO curl may not exist, also depends on git
[ -z "$(command -v brew)" ] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
[ -z "$(command -v rg)" ] && brew install ripgrep
[ -z "$(command -v pipx)" ] && brew install pipx


# brew outputs bash completion file locations, capture and source
# ==> Caveats
# Bash completion has been installed to:
#   /home/linuxbrew/.linuxbrew/etc/bash_completion.d
# https://docs.brew.sh/Shell-Completion

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

git clone https://github.com/Aloxaf/fzf-tab $HOME/dotfiles/fzf-tab/

[ ! -z "$(command -v wget)" ] && wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -q

source shell_config.sh
