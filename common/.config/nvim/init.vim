call plug#begin('~/.vim/plugged')

" baseline nice things
Plug 'rafi/awesome-vim-colorschemes'
Plug 'scrooloose/nerdcommenter'
Plug 'w0rp/ale'
Plug 'neomake/neomake'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" finding stuff
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'

" tmux
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'

" langauge specific
Plug 'fatih/vim-go'
Plug 'zah/nim.vim'
Plug 'elzr/vim-json'

call plug#end()

set rtp+=~/.fzf

set number
set bg=dark
if has('nvim')
    set guicursor=
endif
colo gruvbox

let g:sessions_dir = '~/.vim-sessions'

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

augroup vimrc
    autocmd!
    autocmd Filetype make       setlocal noexpandtab
    autocmd Filetype javascript setlocal ts=2 sw=2
    autocmd Filetype html       setlocal ts=2 sw=2
    autocmd Filetype lua        setlocal ts=2 sw=2

    autocmd BufWritePost ~/.config/nvim/init.vim source ~/.config/nvim/init.vim 
augroup END

if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif
let g:ack_qhandler = "botright copen"

let g:ale_cpp_gcc_options = '-std=c++11 -Wall'

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
nnoremap <leader>w :w<cr>
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

nnoremap <leader>m :set makeprg=/home/jason/build.sh\ 
nnoremap <leader>c :silent wa!<cr> :Neomake! makeprg<cr>

"nnoremap <Left>  :cprev<cr>
"nnoremap <Right> :cnext<cr>
"nnoremap <Up>    :botr copen<cr>
"nnoremap <Down>  :cclose<cr>

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
