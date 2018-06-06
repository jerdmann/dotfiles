call plug#begin('~/.vim/plugged')

Plug 'flazz/vim-colorschemes'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/syntastic'
"Plug 'w0rp/ale'
Plug 'airblade/vim-gitgutter'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'

Plug 'fatih/vim-go'
Plug 'zah/nim.vim'

Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'

call plug#end()

set rtp+=~/.fzf

syntax on
set t_Co=256
set ttyfast
set lazyredraw
set number
"set cursorline

set bg=dark
colo Tomorrow-Night
filetype plugin indent on

let g:sessions_dir = '~/.vim-sessions'
" exec 'nnoremap <Leader>ss :mks! ' . g:session_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'
" exec 'nnoremap <Leader>sr :so ' . g:session_dir. '/*.vim<C-D><BS><BS><BS><BS><BS>'

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

set tw=100
set formatoptions-=t

autocmd Filetype make setlocal noexpandtab
autocmd Filetype javascript setlocal ts=2 sw=2
autocmd Filetype html setlocal ts=2 sw=2

autocmd! bufwritepost ~/.vimrc source ~/.vimrc

"let g:ag_prg="ag --column --nogroup --noheading --nobreak"
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

let g:syntastic_python_checkers = ['pyflakes']
let g:syntastic_cursor_column = 0
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_ruby_mri_args = '-T1 -c'
let g:syntastic_cpp_checkers = []
let g:syntastic_cpp_compiler = "clang++"
let g:syntastic_cpp_compiler_options = "-std=c++11 -Wall"

let g:go_fmt_fail_silently = 0
let g:go_autodetect_gopath = 1
let g:go_highlight_space_tab_error = 0
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_extra_types = 0
let g:go_highlight_operators = 0
let g:go_version_warning = 0

let g:clang_library_path="/usr/lib/llvm-3.5/lib/libclang.so"
let c_space_errors = 1

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
set laststatus=2

set wildmenu
set wildmode=longest:list,full
set wildignore=*.swp,*.pyc

set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L

set pastetoggle=<F2>
"imap kj <Esc>

let g:netrw_liststyle=3

set makeprg=/home/jason/build.sh

let mapleader = "\<Space>"
nnoremap <leader>e :e <C-R>=expand('%:p:h') . '/'<CR>
nnoremap <leader>h /"tags"<cr>O"haproxy": {"weight": 0},<cr><esc>
nnoremap <leader>p "0p
nnoremap <leader>t :%s/\s\+$//e<cr>
nnoremap <leader>w :wa<cr>
nnoremap <leader><space> :noh<cr>

cnoreabbrev Ack Ack!
nnoremap K :Ack!<CR>
nnoremap Q <nop>
nnoremap Y y$

nnoremap <silent> <F7> :cp<cr>
nnoremap <silent> <F8> :cn<cr>
nnoremap <silent> <F9> :cw<cr>

nnoremap <silent> <C-p> :FZF<cr>

nnoremap <leader>b :Buffers<cr>
nnoremap <leader>f :FZF<cr>

" Vimux
let g:VimuxUseNearest = 1
map <silent> <leader>l :wa<CR> :VimuxClearRunnerHistory<CR> :VimuxRunLastCommand<CR>
map <silent> <leader>r :wa<CR> :VimuxPromptCommand<CR>
"map <silent> <leader>t :!ctags price_server lbm<CR>
map <silent> <leader>i :VimuxInspectRunner<CR>
" map <silent> <LocalLeader>vk :wa<CR> :VimuxInterruptRunner<CR>
" map <silent> <LocalLeader>vx :wa<CR> :VimuxClosePanes<CR>
" vmap <silent> <LocalLeader>vs "vy :call VimuxRunCommand(@v)<CR>
" nmap <silent> <LocalLeader>vs vip<LocalLeader>vs<CR>

nnoremap ; :
vnoremap ; :

function! PyMake()
python << EOF
import subprocess
import multiprocessing
import sys

targets = sys.argv[1:]
targets = ["price_client"]
search_path = "misc fixit price_server the_arsenal"
rr = subprocess.check_output("git rev-parse --show-toplevel".split())
out = subprocess.check_output("make -j{} -C {} def_search_path=\"{}\" {}".format(
                            multiprocessing.cpu_count(), rr, search_path, " ".join(targets)),
                            stderr=subprocess.STDOUT)

EOF
endfunc
