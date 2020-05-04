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
    set termguicolors  " Better colors, works on most terminals
    let $NVIM_LISTEN_ADDRESS=v:servername
    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath = &runtimepath
    set autoindent  " Match indentation of above line
    set autoread  " Read in outside changes to file

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
        Plug 'junegunn/fzf', { 'do': 'sh install --all' }
        Plug 'junegunn/fzf.vim'
        Plug 'prabirshrestha/async.vim'
        Plug 'prabirshrestha/vim-lsp'
        Plug 'prabirshrestha/asyncomplete.vim'
        Plug 'prabirshrestha/asyncomplete-lsp.vim'
        Plug 'mattn/vim-lsp-settings'
        Plug 'cohama/lexima.vim'
        Plug 'lambdalisue/suda.vim'
    call plug#end()


" Plugin settings
let g:fzf_buffers_jump = 1
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
let g:slime_no_mappings = 0
let g:onedark_termcolors=256
colorscheme onedark
highlight Normal ctermbg=232 guibg=Black " Pitch black background
set completeopt-=preview  " Make it so completions don't open a preview window
let g:black_skip_string_normalization = 1
let g:black_linelength = 79
" autocmd BufWritePre *.py silent! execute ':silent! Black'
autocmd BufRead ~/notes execute 'set filetype=markdown'

" change vim cwd to file wd
command! CD execute ":cd %:p:h"
" paste in command mode
" cmap <c-p> <c-r>"
" used to be ^, switching to below helped when pasting from x11 selection
cmap <c-p> <c-r>+
" turn off middle click paste
map <MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>
" paste in terminal mode
tmap <c-p> <c-\><c-n>""pi
tmap <esc> <c-\><c-n>
nmap - :bn<CR>
nmap = <C-w><C-w>
" Toggle folds with q in normal mode
nmap <space> za
nmap <BS> X
" Make <Esc><Esc> clear search highlights
nmap <silent> <Esc><Esc> <Esc>:noh<CR><Esc>
" Tab cycles through autocompletions if the autocompletion menu is open
imap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" Enter selects an autocompletion if in the autocompletion menu
imap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
" C-n Toggles NERDTree
nmap <C-n> :NERDTreeToggle<CR>
nmap gd :LspDefinition<cr>
nmap <leader>b :Buffers<cr>
nmap <leader>c :History:<cr>
nmap <leader>d :call fzf#run({'source': 'find ~ -type d', 'sink': 'cd'})<cr>
nmap <leader>f :Files<cr>
nmap <leader>h :Helptags<cr>
nmap <leader>r :Rg<cr>
nmap <leader>s :History/<cr>
nmap <leader>t :term<cr>
nmap <leader>x <Plug>SlimeParagraphSend
xmap <leader>x <Plug>SlimeRegionSend
nmap <leader>: :History:<cr>
nmap <leader>/ :History/<cr>

packloadall  " Load all packages now
silent! helptags ALL  " Load all helptags in package docs
