" Simple settings
    set encoding=utf-8
    set list listchars=tab:!·,extends:$,precedes:$,space:·  " Characters to indicate whitespace
    set splitbelow splitright  " More sensible window splits
    set tabstop=4 shiftwidth=4 expandtab  " Tabs are 4 spaces
    set colorcolumn=80  " have a highlighted column for PEP8
    set nowrap  " Don't wrap long lines
    set showmatch " highlight matching (, [, {
    set relativenumber number " show line numbers
    set noswapfile  " Disable swap files
    set mouse=a  " use mouse for selection, scrolling, eta
    set hidden  " allow hidden buffers
    set hls ic is smartcase  " Highlight search results, ignore case on searches, search as you type
    set foldmethod=indent  " Fold lines on same indent
    set foldlevel=99  " Open all folds
    set fileformat=unix  " newline line endings
    set fileignorecase  " turn off case sensitive completions for file and dir completions
    set wildmode=longest,list,full  " Bash like file completions in ex command
    set wildmenu  " Disable cycle menu in ex file completions
    set clipboard+=unnamedplus,unnamed  " Use the + register on copy (the system clipboard)
    set confirm  " Confirm whether to save when quitting with unsaved changes
    set noshowmode  " Don't show mode in command line when switching modes
    set laststatus=2  " Always show statusline
    set switchbuf=useopen  " Switch to window with buffer if one exists
    let $NVIM_LISTEN_ADDRESS=v:servername

" Things that are specific to nvim vs vim
    if has("nvim")
        set guicursor=  " So cursor is visible (block) in insert mode
        set runtimepath^=~/.vim runtimepath+=~/.vim/after
        let &packpath = &runtimepath
    else
        " Things that nvim has by default
        set autoindent  " Match indentation of above line
        filetype plugin indent on
        set autoread  " Read in outside changes to file
    endif

" Plugins
    " https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
    call plug#begin()
        Plug 'sheerun/vim-polyglot'
        Plug 'joshdick/onedark.vim'
        Plug 'python/black'
        Plug 'scrooloose/nerdtree'
        Plug 'tmux-plugins/vim-tmux-focus-events'
        Plug 'tpope/vim-commentary'
        Plug 'godlygeek/tabular'
        Plug 'tpope/vim-fugitive'
        Plug 'itchyny/lightline.vim'
        Plug 'jpalardy/vim-slime'
        Plug 'brettanomyces/nvim-editcommand'
        Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
        Plug 'junegunn/fzf.vim'
        Plug 'prabirshrestha/async.vim'
        Plug 'prabirshrestha/vim-lsp'
        Plug 'prabirshrestha/asyncomplete.vim'
        Plug 'prabirshrestha/asyncomplete-lsp.vim'
        Plug 'mattn/vim-lsp-settings'
        Plug 'cohama/lexima.vim'
    call plug#end()


" Plugin settings
let g:editcommand_prompt = '$'
let g:editcommand_no_mappings = 1
tmap <c-x> <Plug>EditCommand
let g:lightline = {
    \ 'active': {
    \ 'left' : [['mode', 'filename', 'modified']],
    \ 'right': [['lineinfo', 'percent', 'filetype', 'gitbranch']],
    \ },
    \ 'component': {'charvaluehex': '0x%B', 'filename': '%f'},
    \ 'component_function': {'gitbranch': 'FugitiveHead'},
\ }

let g:slime_target = "neovim"
let g:slime_python_ipython = 1
let g:onedark_termcolors=256
colorscheme onedark
highlight Normal ctermbg=232  " Pitch black background
set completeopt-=preview  " Make it so completions don't open a preview window
let g:black_skip_string_normalization = 1
let g:black_linelength = 79
" autocmd BufWritePre *.py silent! execute ':silent! Black'
autocmd BufRead ~/notes execute 'set filetype=markdown'

" change vim cwd to file wd
command! CD execute ":cd %:p:h"
" close all buffers except current
command! BD execute ":%bd|e#|bd#"
" paste in command mode
" cmap <c-p> <c-r>"
" used to be ^, switching to below helped when pasting from x11 selection
cmap <c-p> <c-r>+
" turn off middle click paste
map <MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>
" paste in terminal mode
tmap <c-p> <c-\><c-n>""pi
" Make ESC work in terminal mode
tmap <esc> <c-\><c-n>
" Set ` to cycle buffers
nmap - :bn<CR>
" Set = to cycle windows in normal mode
nmap = <C-w><C-w>
" Toggle folds with q in normal mode
nmap <space> za
" Make backspace work in normal mode
nmap <BS> X
" Make <Esc><Esc> clear search highlights
nmap <silent> <Esc><Esc> <Esc>:noh<CR><Esc>
" Tab cycles through autocompletions if the autocompletion menu is open
imap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" Enter selects an autocompletion if in the autocompletion menu
imap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
" C-n Toggles NERDTree
map <C-n> :NERDTreeToggle<CR>
nmap gd :LspDefinition<cr>

packloadall  " Load all packages now
silent! helptags ALL  " Load all helptags in package docs
