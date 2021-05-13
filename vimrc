" Simple settings
    set autochdir  " Auto change to dir of open file
    set inccommand=nosplit " Show commands effects (such as substitutions) while entering
    set modeline " File modelines
    set encoding=utf-8
    set list listchars=tab:!·,extends:$,precedes:$,space:·  " Characters to indicate whitespace
    set splitbelow splitright  " More sensible window splits
    set tabstop=4 shiftwidth=4 expandtab  " Tabs are 4 spaces
    set colorcolumn=80  " have a highlighted column for PEP8
    set showmatch " highlight matching (, [, {
    set relativenumber number " current line has actual line number, above and below are relative
    set noswapfile  " Disable swap files (unsaved work will be lost on crash)
    set mouse=a  " use mouse for selection, scrolling, eta
    set hidden  " allow hidden buffers (open files you cannot see)
    set hls ic is smartcase  " Highlight search results, ignore case on searches, search as you type
    set foldmethod=indent  " Fold lines on same indent
    set foldlevel=99  " Open all folds
    set fileformat=unix  " newline line endings (\n)
    set fileignorecase  " turn off case sensitive completions for file and directory completions
    set wildmode=longest,list,full  " Bash like file completions in ex command
    set wildmenu  " Disable cycle menu in ex file completions
    set clipboard+=unnamedplus,unnamed  " Use system clipboard for yank and put
    set confirm  " Confirm whether to save when quitting with unsaved changes
    set laststatus=2  " Always show statusline
    set switchbuf=useopen  " When opening a file, switch to buffer if one already exists
    let $NVIM_LISTEN_ADDRESS=v:servername " set environment variable for neovim-remote
    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath = &runtimepath
    set autoindent  " Match indentation of above line
    set autoread  " Read in outside changes (if file gets changed elsewhere)
    set scrolloff=2 " When scrolling, keep the cursor two lines from the end
    set breakindent  " Maintain indentation on linebreaks
    set showbreak=>  " Show linebreaks
    set lbr  " break lines on words
    set nofixeol  " Don't add newlines to end of files

    au BufRead *.csv setlocal ft= " disable CSV filetype (seems resource intensive)
    au TermOpen * setlocal nonumber " in terminal mode, don't use absolute line number

" Plugins
    " Install vim-plug if not already there
    " https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
    call plug#begin()
        Plug 'sheerun/vim-polyglot' " A collection of language packs for Vim.
        Plug 'joshdick/onedark.vim' " Colortheme
        Plug 'tpope/vim-commentary' " Comment stuff out with gcc for a line, gc for a selection or motion
        Plug 'jpalardy/vim-slime' " Send lines or selected text to terminal window
        Plug 'brettanomyces/nvim-editcommand' " Edit command line in terminal with ctrl-x ctrl-e
        Plug 'junegunn/fzf', { 'do': 'bash install --all' } " Fuzzy Finder
        Plug 'junegunn/fzf.vim' " Fuzzy Finder commands for vim
        Plug 'junegunn/vim-peekaboo' " Show register contents when accessing named registers
        Plug 'jiangmiao/auto-pairs' " automatically pair quotes, parentheses, brackets, curly braces, backticks
        Plug 'lambdalisue/suda.vim' " Save as sudo with :SudaWrite
        Plug 'tyru/open-browser.vim' " open URLs in browser with gx
        Plug 'frazrepo/vim-rainbow' " Color match parentheses, brackets, curly braces
        Plug 'moll/vim-bbye' " Commands to sanely close buffers
        Plug 'tpope/vim-unimpaired' " Mappings for common things
        Plug 'tpope/vim-repeat' " Repeat things from vim-unimpaired

        Plug 'tpope/vim-fugitive' " Git integration
        Plug 'tommcdo/vim-fubitive' " Gbrowse bitbucket

        Plug 'neovim/nvim-lspconfig'
        Plug 'hrsh7th/nvim-compe'

        Plug 'easymotion/vim-easymotion'
        Plug 'gu-fan/riv.vim'
    call plug#end()

" Plugin settings
let g:fubitive_domain_pattern = 'bitbucket\.build\.dkinternal\.com'
let g:riv_disable_indent = 1
let g:rainbow_active = 1
let g:openbrowser_default_search = 'duckduckgo'
let g:peekaboo_window = 'vert bo 40new'
let g:fzf_buffers_jump = 1
let g:editcommand_prompt = '>'
let g:slime_target = "neovim"
let g:slime_python_ipython = 1
let g:slime_no_mappings = 0
let g:onedark_termcolors=256
colorscheme onedark
highlight Normal ctermbg=232 guibg=Black " Pitch black background
set completeopt=menuone,noinsert,noselect


" statusline
highlight StatusLine ctermfg=46 ctermbg=232
set statusline=%#StatusLine#
set statusline+=%f\ %m%y\ %l:%c\ %p%%\ Ch:%{&channel}\ %=
set statusline+=%<\ %{systemlist('date\ \"+%a\ %d\ %b\ %H:%M:%S\ %:::z\"')[0]}

" Mappings
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap <C-Left> <C-w>h
nmap <C-Down> <C-w>j
nmap <C-Up> <C-w>k
nmap <C-Right> <C-w>l
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
map <space> <leader>
" turn off middle click paste
map <MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>
tmap <esc> <c-\><c-n>
nmap <BS> X
" Make <Esc><Esc> clear search highlights
nmap <silent> <Esc><Esc> <Esc>:noh<CR><Esc>
" Tab cycles through autocompletions if the autocompletion menu is open
imap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" Enter selects an autocompletion if in the autocompletion menu
imap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

nmap <leader>ld :lua vim.lsp.buf.definition()<cr>
nmap <leader>lh :lua vim.lsp.buf.hover()<cr>
" nmap <leader>lr :lua vim.lsp.buf.references()<cr>
nmap <leader>lr :lua vim.lsp.buf.rename()<cr>
nmap <leader>lf :lua vim.lsp.buf.formatting()<cr>

nmap <leader>b :Buffers<cr>
nmap <leader>c :History:<cr>
nmap <leader>e :SlimeSend<cr>
xmap <leader>e <Plug>SlimeRegionSend
" TODO make Files vs GFiles depend on whether in git repo or not
nmap <leader>f :Files ~<cr>
nmap <leader>g :GFiles<cr>
nmap <leader>h :Helptags<cr>
nmap <leader>k :Bdelete<cr>
nmap <leader>K :bdelete<cr>
nmap <leader>p "0p
nmap <leader>P "0P
nmap <leader>s :History/<cr>
nmap <leader>t :term<cr>
nmap <leader>T :vnew term://bash<cr>
nmap <leader>w :w<cr>
nmap <leader>z za
nmap <leader>/ :History/<cr>
" TODO explore v and o mode mappings
nmap f <Plug>(easymotion-s)
nmap F <Plug>(easymotion-sn)
nmap w <Plug>(easymotion-overwin-w)
nmap W <Plug>(easymotion-bd-W)

packloadall  " Load all packages now
silent! helptags ALL  " Load all helptags in package docs

function! UpdateStatusLine(timer)
    execute 'let &ro = &ro'
endfunction
let timer = timer_start(1000, 'UpdateStatusLine', {'repeat':-1})

" TODO setup language server installation
lua << EOF
require'lspconfig'.pyls.setup{}
require'lspconfig'.terraformls.setup{}

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
  };
}
EOF
