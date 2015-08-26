set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'davidhalter/jedi-vim'
Plugin 'sjl/badwolf'
Plugin 'kien/ctrlp.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'rking/ag.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-surround'
Plugin 'Raimondi/delimitMate'
Plugin 'ervandew/supertab'
Plugin 'christoomey/vim-tmux-navigator'
call vundle#end()
set t_Co=256
colors badwolf
" colorcolumn is apparently not supported in the centos 6.4 vim
call system("test -f /etc/debian_version")
if v:shell_error == 0
    set colorcolumn=+1
endif
filetype plugin indent on

set autoindent
set autowrite
set nobackup
set expandtab
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set shiftround

let g:ctrlp_by_filename = 1
let g:ctrlp_working_path=0
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

let g:ag_prg="ag --column --nogroup --noheading --nobreak"

let g:syntastic_python_checkers = ['pyflakes']
let g:syntastic_enable_perl_checker = 1
let g:syntastic_cursor_column = 0
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_ruby_mri_args = '-T1 -c'

set history=1000
set clipboard=unnamed
set go+=a
set shortmess=atI
set autoread

syntax on
set t_ut=
set title
set ttyfast
set lazyredraw

set ignorecase
set smartcase
set incsearch
set hlsearch

set splitbelow
set splitright
set ruler
set showcmd
set hidden
set scrolloff=3
set scrolljump=6
set laststatus=2

set wildmenu
set wildmode=list:longest,full
set wildignore=*.swp,*.pyc

set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L

set pastetoggle=<F2>
imap kj <Esc>

" Preserve terminal background color.
hi Normal ctermbg=none
hi NonText ctermbg=none

" Trim trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

autocmd Filetype python set textwidth=100

let mapleader = ","
nnoremap <leader>l :set invrelativenumber<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader><space> :noh<cr>

nnoremap gl :b#<CR>
nnoremap Q <nop>
nnoremap Y y$

nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l

nnoremap ; :
vnoremap ; :
