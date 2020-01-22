call plug#begin('~/.vim/plugged')

" baseline nice things
Plug 'rafi/awesome-vim-colorschemes'
Plug 'w0rp/ale'
Plug 'neomake/neomake'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'airblade/vim-gitgutter'
" Plug 'xolox/vim-misc'

" finding stuff
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" tmux
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'

" langauge specific
Plug 'fatih/vim-go'
Plug 'elzr/vim-json'
Plug 'rhysd/vim-clang-format'
Plug 'zah/nim.vim'

" shenanigans
Plug 'triglav/vim-visual-increment'
call plug#end()

set rtp+=~/.fzf
set shell=/bin/bash

" set number
set bg=dark
if has('nvim')
    set guicursor=
endif
colo gruvbox

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

set tw=100
set formatoptions-=t
set mouse=a
set scrolljump=-50

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

    autocmd Filetype      cpp   let b:commentary_format = '// %s'
    " TODO.  weird paranoid cpp-only trimming. The random filetype actually has significant
    " trailing whitespace so be a wuss for now.
    autocmd BufWritePre *.cpp,*.h,*.inl,*.md     :call TrimTrailingWhitespace()

    autocmd BufWritePre *.cpp,*.h,*.inl :%s/\s\+$//e

    autocmd BufWritePost ~/.config/nvim/init.vim source ~/.config/nvim/init.vim 

    autocmd QuickFixCmdPre build.sh RepoRoot()
    autocmd QuickFixCmdPost [^l]* cwindow

    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost * if line("'\"") | exe "'\"" | endif
augroup END

let g:ale_cpp_gcc_options = '-std=c++14 -Wall'
let g:ale_open_list = 0
" debesys env is annoying, revisit
let g:ale_enabled = 0

let g:neomake_logfile = '/tmp/neomake.log'
let g:neomake_open_list = 2
call neomake#configure#automake('w')

function! MyOnNeomakeJobFinished() abort
    let context = g:neomake_hook_context
    echom printf('maker %s complete rc=%i',
                \ context.jobinfo.maker.name, context.jobinfo.exit_code)
endfunction
augroup my_neomake_hooks
    au!
    autocmd User NeomakeJobFinished call MyOnNeomakeJobFinished()
augroup END

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

set history=1000
set clipboard=unnamedplus
set go+=a
set shortmess=atI

set ignorecase
set smartcase
set incsearch
set hlsearch
set scrolljump=-50

  "'cpoptions' flags: |cpo-_|
  "'display' flag `msgsep` to minimize scrolling when showing messages
  "'guicursor' works in the terminal
  "'fillchars' flag `msgsep` (see 'display' above)
  "'inccommand' shows interactive results for |:substitute|-like commands
  "'scrollback'
  "'statusline' supports unlimited alignment sections
  "'tabline' %@Func@foo%X can call any function on mouse-click
  "'winhighlight' window-local highlights

set inccommand=nosplit

set splitbelow
set splitright
set hidden

set wildmenu
set wildmode=longest:list,full
set wildignore=*.swp,*.pyc

set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L

set pastetoggle=<F2>

let g:netrw_banner = 0
let g:netrw_liststyle=3

let mapleader = "\<Space>"
nnoremap <leader>e :e <C-R>=expand('%:p:h') . '/'<cr>
nnoremap <leader>g :grep! 
nnoremap <leader>q :bp\|bd \#<cr>
nnoremap <leader><space> :noh<cr>

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
else
  set grepprg=git\ --no-pager\ grep\ --no-color\ -n\ $*
  set grepformat=%f:%l:%m,%m\ %f\ match%ts,%f
endif

nnoremap K :grep! <cword><cr>:botright cw<cr> 
nnoremap Q <nop>
nnoremap Y y$

" FZF is life changing
nnoremap <silent> <C-p> :FZF<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>f :FZF<cr>
nnoremap <leader>l :Lines<cr>

" lame debug
nnoremap <silent> <leader>d <esc>Oprintf("TRACE ===> %s: \n", __func__);<esc>BBi

nnoremap <leader>m :silent wa!<cr> :Neomake! makeprg<cr>

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

nnoremap ; :
vnoremap ; :

