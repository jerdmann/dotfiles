if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    sh -c 'curl -fLo "~/.local/share"/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
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

    " finding stuff
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'

    " tmux
    Plug 'benmills/vimux'
    Plug 'christoomey/vim-tmux-navigator'

    " langauge specific
    Plug 'elzr/vim-json'
    Plug 'fatih/vim-go'
    Plug 'rhysd/vim-clang-format'
    Plug 'rust-lang/rust.vim'

    " shenanigans
    Plug 'triglav/vim-visual-increment'

    call plug#end()
endif

set rtp+=~/.fzf
set shell=/bin/bash

set number
set bg=dark
if has('nvim')
    set guicursor=
endif
colo gruvbox
hi Normal guibg=NONE ctermbg=NONE

"regrettably living in a world with heaps of legacy code.  revisit
"let g:clang_format#auto_format = 1
"let g:clang_format#auto_formatexpr = 1
"let g:clang_format#auto_format_on_insert_leave = 1

set nobackup
set autowrite
set autoread
set shiftround
set smarttab
set shiftwidth=4
set softtabstop=4
set expandtab
set tags=tags;

set tw=80
set formatoptions-=t
set mouse=a

function! OnTabEnter(path)
    if isdirectory(a:path)
        let dirname = a:path
    else
        let dirname = fnamemodify(a:path, ":h")
    endif
    execute "tcd ". dirname
endfunction()

function! TrimTrailingWhitespace()
    let l:winview = winsaveview()
    silent! %s/\s\+$//
    call winrestview(l:winview)
endfunction

augroup vimrc
    autocmd!
    autocmd Filetype make       setlocal noexpandtab
    autocmd Filetype javascript setlocal ts=2 sw=2
    autocmd Filetype html       setlocal ts=2 sw=2
    autocmd Filetype lua        setlocal ts=2 sw=2

    autocmd Filetype ruby       setlocal ts=4 sw=4

    autocmd Filetype      cpp   let b:commentary_format = '// %s'
    " TODO.  weird paranoid cpp-only trimming. The random filetype actually has significant
    " trailing whitespace so be a wuss for now.
    autocmd BufWritePre *.cpp,*.h,*.inl,*.md,*.py,*.rb,*.rs  :call TrimTrailingWhitespace()

    autocmd BufWritePre *.cpp,*.h,*.inl :%s/\s\+$//e

    autocmd BufWritePost ~/.config/nvim/init.vim source ~/.config/nvim/init.vim 

    autocmd QuickFixCmdPre build.sh RepoRoot()
    autocmd QuickFixCmdPost [^l]* cwindow

    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost * if line("'\"") | exe "'\"" | endif
augroup END

let g:ale_linters = {'python': ['pyflakes']}
let g:ale_cpp_cc_executable = 'clang++-9'
let g:ale_cpp_gcc_options = '-std=c++17 -Wall'

silent! mkdir ~/.vim/undodir > /dev/null 2>&1
set undofile
set undodir=~/.vim/undodir

let g:go_fmt_fail_silently = 0
let g:go_autodetect_gopath = 1
let g:go_highlight_space_tab_error = 0
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_extra_types = 0
let g:go_highlight_operators = 0
let g:go_version_warning = 0

let g:vim_json_syntax_conceal = 0

set history=10000
set clipboard=unnamedplus
set go+=a
set shortmess=actI

set ignorecase
set smartcase
set incsearch
set hlsearch

set scrolloff=2

set inccommand=nosplit

set splitbelow
set splitright
set hidden
set diffopt+=vertical

set wildmenu
set wildmode=longest:list,full
set wildignore=*.swp,*.pyc

set pastetoggle=<F2>

let g:netrw_banner = 0
let g:netrw_liststyle=3

let mapleader = "\<Space>"
nnoremap <leader>e :e <C-R>=expand('%:p:h') . '/'<cr>
nnoremap <leader>g :grep! 
nnoremap <leader>q :bp \| bd #<cr>
nnoremap <leader><leader> :b#<cr>

if executable('rg')
  set grepprg=rg\ --vimgrep
else
  set grepprg=git\ --no-pager\ grep\ --no-color\ -n\ $*
  set grepformat=%f:%l:%m,%m\ %f\ match%ts,%f
endif

nnoremap K :grep! -w <cword><cr>:vert copen 80<cr> 
nnoremap Q <nop>
nnoremap Y y$

" FZF is life changing
nnoremap <silent> <C-p> :FZF<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>f :FZF<cr>
nnoremap <leader>t :Tags<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>fl :Lines<cr>
nnoremap <leader>fr :Rg<cr>

" lame debug
nnoremap <silent> <leader>d <esc>Oprintf("TRACE ===> %s: \n", __func__);<esc>BBi

nnoremap <leader>m :make<cr>:botright cw<cr>

nnoremap <C-Left>  :cprev<cr>
nnoremap <C-Right> :cnext<cr>
nnoremap <C-Up>    :botr cwin<cr>
nnoremap <C-Down>  :cclose<cr>:lclose<cr>

" Vimux
let g:VimuxUseNearest = 1
map <silent> <leader>r :wa<cr> :VimuxPromptCommand<cr>
map <silent> <leader>l :wa<cr> :VimuxClearRunnerHistory<cr> :VimuxRunLastCommand<cr>
map <silent> <leader>i :VimuxInspectRunner<cr>
" map <silent> <leader>vk :VimuxInterruptRunner<cr>

" map <silent> <LocalLeader>vx :wa<cr> :VimuxClosePanes<cr>
" vmap <silent> <LocalLeader>vs "vy :call VimuxRunCommand(@v)<cr>
" nmap <silent> <LocalLeader>vs vip<LocalLeader>vs<cr>

if has('nvim')
    tnoremap <Esc> <C-\><C-n>
    tnoremap <Esc> <C-\><C-n>

    tnoremap <A-h> <C-\><C-N><C-w>h
    tnoremap <A-j> <C-\><C-N><C-w>j
    tnoremap <A-k> <C-\><C-N><C-w>k
    tnoremap <A-l> <C-\><C-N><C-w>l
endif

" lame node migrate thing
function FlipNode()
    " grab the exchange name
    call search('mds_adapter_', 'e')
    normal l"eyw
    " smash the old-style runlist entries to the new ones
    execute "%s/mds_price_server::/mds_adapter_" . @e . "::price_server_"
    execute "%s/mds_ppiq::/mds_adapter_" . @e . "::ppiq"
    execute 'wq'
endfunction

nnoremap ; :
vnoremap ; :
