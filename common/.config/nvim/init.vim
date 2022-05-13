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

    " langauge specific
    Plug 'elzr/vim-json'
    Plug 'fatih/vim-go'
    Plug 'rhysd/vim-clang-format'
    Plug 'rust-lang/rust.vim'

    " lsp
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/nvim-cmp', { 'branch': 'main' }
    Plug 'hrsh7th/cmp-nvim-lsp', { 'branch': 'main' }
    Plug 'hrsh7th/cmp-nvim-lua', { 'branch': 'main' }

    " shenanigans
    Plug 'triglav/vim-visual-increment'

    call plug#end()
endif

set rtp+=~/.fzf

if has('nvim')
    set guicursor=
endif
if has('termguicolors')
    set termguicolors
endif

set bg=dark
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
    " TODO.  weird filetype-specific trimming. The random filetype actually has significant
    " trailing whitespace so be a wuss for now.
    autocmd BufWritePre *.cpp,*.h,*.inl,*.md,*.py,*.rb,*.rs  :call TrimTrailingWhitespace()

    autocmd BufWritePost ~/.config/nvim/init.vim source ~/.config/nvim/init.vim 

    " autocmd QuickFixCmdPre build.sh RepoRoot()
    " autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l* lwindow

    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost * if line("'\"") | exe "'\"" | endif
augroup END

let g:ale_enabled = 0
let g:ale_pattern_options = {'\.min.js$': {'ale_enabled': 0}}
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
set clipboard=unnamedplus
set go+=a
set shortmess=actI

set ignorecase
set smartcase
set incsearch
set hlsearch

set cursorline
set scrolloff=8

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
nnoremap <leader>fl :Lines<cr>
nnoremap <leader>fr :Rg<cr>

" lame debug
nnoremap <silent> <leader>d <esc>Oprintf("TRACE ===> %s: \n", __func__);<esc>BBi

nnoremap <leader>w :w<cr>
nnoremap <leader>m :make<cr>:botright cw<cr>

nnoremap <silent> <leader>l :wa<cr> :silent !tmux send-keys -t {next} -X cancel; tmux send-keys -Rt {next} Up Enter<cr>

noremap <leader>p :read !xsel --clip --output<cr>
noremap <leader>c :w !xsel -ib<cr><cr>

vnoremap <C-h> :nohlsearch<cr>
nnoremap <C-h> :nohlsearch<cr>

nnoremap ; :
vnoremap ; :

map <F1> <Esc>
imap <F1> <Esc>

lua << EOF

-- require('lspconfig').clangd.setup{}
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

vim.lsp.set_log_level("debug")

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- local servers = { 'clangd' }
local servers = {}
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    }
  }
end
EOF
