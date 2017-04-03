set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'davidhalter/jedi-vim'
Plugin 'flazz/vim-colorschemes'
Plugin 'kien/ctrlp.vim'
Plugin 'rking/ag.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/syntastic'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'fatih/vim-go'
Plugin 'elonwoo/vim-material-theme'
Plugin 'tpope/vim-dispatch'

call vundle#end()

syntax on
set t_ut=
set t_Co=256
set ttyfast
set lazyredraw

colors Tomorrow-Night-Eighties
filetype plugin indent on
set number
set cursorline

set autoindent
set autoread
set nobackup
set shiftround
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set tags=tags;
set backspace=indent,eol,start
set number
set cursorline
set mouse=a

augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

autocmd Filetype make setlocal noexpandtab
autocmd Filetype javascript setlocal ts=2 sw=2
autocmd Filetype html setlocal ts=2 sw=2

let g:ctrlp_by_filename = 1
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

let g:ag_prg="ag --column --nogroup --noheading --nobreak"

let g:syntastic_python_checkers = ['pyflakes']
let g:syntastic_cursor_column = 0
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_ruby_mri_args = '-T1 -c'
let g:syntastic_cpp_compiler = "clang++"
let g:syntastic_cpp_compiler_options = "-std=c++11 -Wall"

let g:go_fmt_fail_silently = 0
let g:go_autodetect_gopath = 1
let g:go_highlight_space_tab_error = 0
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_extra_types = 0
let g:go_highlight_operators = 0

let g:clang_library_path="/usr/lib/llvm-3.5/lib/libclang.so"

set history=1000
set clipboard=unnamedplus
set go+=a
set shortmess=atI

set ignorecase
set smartcase
set incsearch
set hlsearch

set splitbelow
set splitright
set ruler
set showcmd
set hidden
set scrolljump=8
set laststatus=2

set wildmenu
set wildmode=longest:list,full
set wildignore=*.swp,*.pyc

set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L

set pastetoggle=<F2>
imap kj <Esc>

let g:netrw_liststyle=3

let mapleader = ","
nnoremap <leader>a :Ag
nnoremap <leader>e :e <C-R>=expand('%:p:h') . '/'<CR>
nnoremap <leader>l oTTLOG(INFO, 9999) << "
nnoremap <leader>w :silent wa<cr>
nnoremap <leader><space> :noh<cr>
nnoremap <leader>rs :%s/\s\+$//e<cr>
nnoremap <leader>h o"haproxy": {"weight": 0}, "edgeserver": {"ttprice_enabled": true},<cr><esc>

nnoremap gl :ls<CR>:b<Space>
nnoremap Q <nop>
nnoremap Y y$

"set makeprg=make\ -j4\ -C\ /home/jason/dev-root/debesys-two\ price_client_test
set makeprg=/home/jason/build.sh\ one\ price_unifier_test

nnoremap <silent> <F5> :silent make \| redraw!<cr>
nnoremap <silent> <F7> :cp<cr>
nnoremap <silent> <F8> :cn<cr>
nnoremap <silent> <F9> :copen<cr>
nnoremap <silent> <F10> :ccl<cr>

nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l

nnoremap ; :
vnoremap ; :


