call plug#begin('~/.vim/plugged')

" baseline nice things
Plug 'rafi/awesome-vim-colorschemes'
Plug 'w0rp/ale'
Plug 'neomake/neomake'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" Plug 'xolox/vim-misc'
" Plug 'xolox/vim-session'

" finding stuff
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'

" tmux
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'

" langauge specific
Plug 'fatih/vim-go'
Plug 'elzr/vim-json'
Plug 'rhysd/vim-clang-format'

" shenanigans
Plug 'triglav/vim-visual-increment'
call plug#end()

set rtp+=~/.fzf
set shell=/bin/bash

set number
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

function! OnTabEnter(path)
    if isdirectory(a:path)
        let dirname = a:path
    else
        let dirname = fnamemodify(a:path, ":h")
    endif
    execute "tcd ". dirname
endfunction()

augroup vimrc
    autocmd!
    autocmd Filetype make       setlocal noexpandtab
    autocmd Filetype javascript setlocal ts=2 sw=2
    autocmd Filetype html       setlocal ts=2 sw=2
    autocmd Filetype lua        setlocal ts=2 sw=2

    autocmd Filetype cpp        let b:commentary_format = '// %s'

    autocmd BufWritePost ~/.config/nvim/init.vim source ~/.config/nvim/init.vim 
    autocmd TabNewEntered * call OnTabEnter(expand("<amatch>"))
    autocmd InsertLeave * silent! :update
augroup END

if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif
let g:ack_qhandler = "botright copen"

let g:ale_cpp_gcc_options = '-std=c++11 -Wall'
let g:ale_open_list = 0

let g:neomake_logfile = '/tmp/neomake.log'
let g:neomake_open_list = 2
call neomake#configure#automake('w')

function! MyOnNeomakeJobFinished() abort
    let context = g:neomake_hook_context
    if context.jobinfo.exit_code == 0
        echom printf('maker %s successful',
                    \ context.jobinfo.maker.name)
    endif
endfunction
augroup my_neomake_hooks
    au!
    autocmd User NeomakeJobFinished call MyOnNeomakeJobFinished()
augroup END

let g:go_fmt_fail_silently = 0
let g:go_autodetect_gopath = 1
let g:go_highlight_space_tab_error = 0
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_extra_types = 0
let g:go_highlight_operators = 0
let g:go_version_warning = 0

let g:vim_json_syntax_conceal = 0

let g:sessions_dir = '/home/jason/.vim-sessions'
call mkdir(g:sessions_dir, "p")
let g:session_autosave        = 'yes'
let g:session_default_to_last = 'yes'
let g:session_directory       = g:sessions_dir

set history=1000
set clipboard=unnamedplus
set go+=a
set shortmess=atI

set ignorecase
set smartcase
set incsearch
set hlsearch

  "if has('nvim')
      "tnoremap <Esc> <C-\><C-n>
  "endif
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

let g:netrw_liststyle=3

let mapleader = "\<Space>"
nnoremap <leader>e :e <C-R>=expand('%:p:h') . '/'<cr>
nnoremap <leader>h /"tags"<cr>O"haproxy": {"weight": 0},<cr><esc>
nnoremap <leader>p "0p
nnoremap <leader>t :%s/\s\+$//e<cr>
nnoremap <leader><space> :noh<cr>

cnoreabbrev Ack Ack!
cnoreabbrev Ag Ack!
nnoremap K :Ack!<cr>
nnoremap Q <nop>
nnoremap Y y$

nnoremap <silent> <C-p> :FZF<cr>

nnoremap <leader>a :Ack 
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>f :FZF<cr>
nnoremap <leader>g :AckWindow! 
nnoremap <silent> <leader>d <esc>OTTLOG(INFO, 9999) << __FUNCTION__ << " 

nnoremap <leader>m :silent wa!<cr> :Neomake! makeprg<cr>

nnoremap <C-Left>  :cprev<cr>
nnoremap <C-Right> :cnext<cr>
nnoremap <C-Up>    :botr copen<cr>
nnoremap <C-Down>  :cclose<cr>

" Vimux
let g:VimuxUseNearest = 1
map <silent> <leader>l :wa<cr> :VimuxClearRunnerHistory<cr> :VimuxRunLastCommand<cr>
map <silent> <leader>r :wa<cr> :VimuxPromptCommand<cr>
"map <silent> <leader>t :!ctags price_server lbm<cr>
map <silent> <leader>i :VimuxInspectRunner<cr>
" map <silent> <LocalLeader>vk :wa<cr> :VimuxInterruptRunner<cr>
" map <silent> <LocalLeader>vx :wa<cr> :VimuxClosePanes<cr>
" vmap <silent> <LocalLeader>vs "vy :call VimuxRunCommand(@v)<cr>
" nmap <silent> <LocalLeader>vs vip<LocalLeader>vs<cr>

nnoremap ; :
vnoremap ; :
