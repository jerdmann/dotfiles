let plug_file = "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
if empty(glob(plug_file))
  silent execute '!curl -fLo ' . plug_file . ' --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

if filereadable(expand('~/.local/share/nvim/site/autoload/plug.vim'))
    call plug#begin('~/.vim/plugged')

    " baseline nice things
    Plug 'airblade/vim-gitgutter'
    Plug 'gruvbox-community/gruvbox'
    Plug 'tpope/vim-abolish'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-unimpaired'
    Plug 'w0rp/ale'

    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

    " finding stuff
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'

    " langauge specific
    Plug 'elzr/vim-json'
    Plug 'fatih/vim-go'
    Plug 'rhysd/vim-clang-format'
    Plug 'rust-lang/rust.vim'

    " lsp
    " Plug 'neovim/nvim-lspconfig'
    " Plug 'hrsh7th/nvim-cmp', { 'branch': 'main' }
    " Plug 'hrsh7th/cmp-nvim-lsp', { 'branch': 'main' }
    " Plug 'hrsh7th/cmp-nvim-lua', { 'branch': 'main' }

    " shenanigans
    Plug 'triglav/vim-visual-increment'

    call plug#end()
endif

set rtp+=~/.fzf

if has('nvim')
    set guicursor=
endif

set bg=dark
let g:gruvbox_contrast_dark="soft"
colo gruvbox

set nobackup
set autowrite
set autoread
set shiftround
set smarttab
set shiftwidth=4
set softtabstop=4
set expandtab
set tags=tags;

set tw=100
set formatoptions-=t
set mouse=a

function! TrimTrailingWhitespace()
    let l:winview = winsaveview()
    silent! %s/\s\+$//
    call winrestview(l:winview)
endfunction

augroup vimrc
    autocmd!
    autocmd Filetype go         setlocal noexpandtab
    autocmd Filetype make       setlocal noexpandtab
    autocmd Filetype javascript setlocal ts=2 sw=2
    autocmd Filetype html       setlocal ts=2 sw=2
    autocmd Filetype lua        setlocal ts=2 sw=2

    autocmd Filetype python     setlocal ts=4 sw=4
    autocmd Filetype ruby       setlocal ts=4 sw=4

    autocmd Filetype      cpp   let b:commentary_format = '// %s'

    autocmd BufWritePost ~/.config/nvim/init.vim source ~/.config/nvim/init.vim 

    " autocmd QuickFixCmdPre build.sh RepoRoot()
    " autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost [^l]* botr cwindow
    autocmd QuickFixCmdPost l* botr lwindow

    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
augroup END

let g:ale_enabled = 0
let g:ale_pattern_options = { '\.py$': {'ale_enabled': 1}, '\.rb$': {'ale_enabled': 1}, }
let g:ale_linters = {'python': ['pyflakes']}
" let g:ale_cpp_cc_executable = 'clang++-9'
" let g:ale_cpp_gcc_options = '-std=c++17 -Wall'

let g:go_fmt_fail_silently = 0
let g:go_autodetect_gopath = 1
let g:go_highlight_space_tab_error = 0
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_extra_types = 0
let g:go_highlight_operators = 0
let g:go_version_warning = 0

let g:vim_json_syntax_conceal = 0

silent! mkdir ~/.vim/undodir > /dev/null 2>&1
set undofile
set undodir=~/.vim/undodir

set history=10000
set go+=a
set shortmess=actI

set ignorecase
set smartcase
set incsearch
set hlsearch

set cursorline
set scrolloff=8
set number

set inccommand=nosplit

" set splitbelow
" set splitright
set hidden
set diffopt+=vertical

set wildmenu
set wildmode=longest:list,full
set wildignore=*.swp,*.pyc

set pastetoggle=<F2>

let mapleader = "\<Space>"
nnoremap <leader>e :e <C-R>=expand('%:p:h') . '/'<cr>
nnoremap <leader>g :silent grep! 
nnoremap <leader>k :silent grep! -w <cword><cr>
nnoremap <leader>q :bp \| bd #<cr>
nnoremap <leader><leader> :b#<cr>
nnoremap <leader>w :w<cr>

if executable('rg')
  set grepprg=rg\ --vimgrep
else
  set grepprg=git\ --no-pager\ grep\ --no-color\ -n\ $*
  set grepformat=%f:%l:%m,%m\ %f\ match%ts,%f
endif

nnoremap Q <nop>
nnoremap Y y$

" FZF is life changing
nnoremap <silent> <C-p> :FZF<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>t :Tags<cr>
"nnoremap <leader>g :Rg<cr>

nnoremap <leader>m :make<cr>:botright cw<cr>
nnoremap <silent> <leader>l :wa<cr> :silent !tmux send-keys -t {last} -X cancel; tmux send-keys -Rt {last} Up Enter<cr>

vnoremap <leader>p "+p
vnoremap <leader>y "+y

vnoremap <C-h> :nohlsearch<cr>
nnoremap <C-h> :nohlsearch<cr>

map <F1> <Esc>
imap <F1> <Esc>
