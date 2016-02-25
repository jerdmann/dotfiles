set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'davidhalter/jedi-vim'
Plugin 'flazz/vim-colorschemes'
Plugin 'kien/ctrlp.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'rking/ag.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/syntastic'
Plugin 'Raimondi/delimitMate'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'fatih/vim-go'
Plugin 'msanders/snipmate.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'tpope/vim-fugitive'
call vundle#end()

colors Tomorrow-Night-Eighties
filetype plugin indent on
set number
set cursorline

set autoindent
set autoread
set nobackup
set noswapfile
set shiftround
set shiftwidth=4
set smarttab
set softtabstop=4
set tabstop=4
set expandtab

augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

autocmd Filetype cpp setlocal ts=2 sw=2
autocmd Filetype make setlocal ts=8 noexpandtab
autocmd Filetype javascript setlocal ts=2 sw=2
autocmd Filetype html setlocal ts=2 sw=2
autocmd Filetype python setlocal ts=4 sw=4
autocmd Filetype ruby setlocal ts=4 sw=4

autocmd BufWritePre * :%s/\s\+$//e

let g:ctrlp_by_filename = 1
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

let g:ag_prg="ag --column --nogroup --noheading --nobreak"

let g:syntastic_python_checkers = ['pyflakes']
let g:syntastic_enable_perl_checker = 1
let g:syntastic_cursor_column = 0
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_ruby_mri_args = '-T1 -c'

let g:go_fmt_fail_silently = 0
let g:go_autodetect_gopath = 1
let g:go_highlight_space_tab_error = 0
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_extra_types = 0
let g:go_highlight_operators = 0

let delimitMate_expand_cr = 1

let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0

set history=1000
set clipboard=unnamedplus
set go+=a
set shortmess=atI

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
set scrolljump=10
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

let mapleader = ","
nnoremap <leader>a :Ag
nnoremap <leader>c :ccl<cr>
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
