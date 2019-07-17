set encoding=utf-8
set list listchars=tab:!·,extends:$,precedes:$,space:·  " Characters to indicate whitespace
set splitbelow splitright  " More sensible window splits
set tabstop=4 shiftwidth=4 expandtab  " Tabs are 4 spaces
set colorcolumn=80 " have a highlighted column for PEP8
set nowrap  " Don't wrap long lines
set showmatch " highlight matching (, [, {
set number " show line numbers
set noswapfile  " Disable swap files
set mouse=a " use mouse for selection, scrolling, eta
set hidden " allow hidden buffers
set hls ic is smartcase  " Highlight search results, ignore case on searches, search as you type
set foldmethod=indent  " Fold lines on same indent
set foldlevel=99  " Open all folds
set fileformat=unix  " newline line endings

" Things that are specific to nvim vs vim
if has("nvim")
    set guicursor=  " So cursor is visible (block) in insert mode
else
    " Things that nvim has by default
    set autoindent  " Match indentation of above line
    filetype plugin indent on
    set autoread  " Read in outside changes to file
endif


" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
    if has('nvim')
        Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    else
        Plug 'Shougo/deoplete.nvim'
        Plug 'roxma/nvim-yarp'
        Plug 'roxma/vim-hug-neovim-rpc'
    endif
    " TODO deoplete dependency: `pip[3] install --user --upgrade pynvim
    let g:deoplete#enable_at_startup = 1

    " TODO this depends on rust and rustup default stable
    Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do': 'bash install.sh',
        \ }
    Plug 'sheerun/vim-polyglot'
    Plug 'joshdick/onedark.vim'
    Plug 'mhinz/vim-signify'
    Plug 'python/black'
    Plug 'vimwiki/vimwiki'
    Plug 'junegunn/vim-easy-align'
call plug#end()

" Plugin settings
let g:netrw_dirhistmax = 0  " Stop netrw from saving a history file, below toggles netrw
let g:signify_vcs_list = ['git']
let g:signify_realtime = 1
set signcolumn=yes  " Keep sign column open even if no git changes
let g:onedark_termcolors=256
colorscheme onedark
highlight Normal ctermbg=232  " Pitch black background
" TODO Dependencies need to be installed
let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'python': ['~/.local/bin/pyls']
    \ }
let g:LanguageClient_useVirtualText = 0  " Make it so error messages are not shown inline on screen
set completeopt-=preview  " Make it so completions don't open a preview window
let g:black_skip_string_normalization = 1
let g:black_linelength = 79
autocmd BufWritePre *.py silent! execute ':silent! Black'

" Key mappings
" Set ` to cycle buffers
nmap - :bn<CR>
" Set = to cycle windows in normal mode
nmap = <C-w><C-w>
" Toggle folds with q in normal mode
nmap q za
" Make backspace work in normal mode
nmap <BS> X
" Make <Esc><Esc> clear search highlights
nmap <silent> <Esc><Esc> <Esc>:noh<CR><Esc>
" Tab cycles through autocompletions if the autocompletion menu is open
imap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" Enter selects an autocompletion if in the autocompletion menu
imap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
" C-n Toggles netrw in normal
map <C-n> :Lexplore<CR>
" autoclose (),{},[]
imap ( ()<left>
imap [ []<left>
imap { {}<left>
imap (<CR> (<CR>)<ESC>O
imap {<CR> {<CR>}<ESC>O
imap [<CR> [<CR>]<ESC>O
" Quotes require this special function, otherwise then get infinitely matched
function! CloseQuote(char)
    let char = a:char
    if getline('.')[col('.') - 1] != char
        return char . char . "\<left>"
    else
        return char
    endif
endfunction
imap ' <c-r>=CloseQuote("'")<CR>
imap " <c-r>=CloseQuote('"')<CR>

packloadall  " Load all packages now
silent! helptags ALL  " Load all helptags in package docs
