syntax on
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" INTERFACE

" Ruler
set ruler

" Padding when scrolling
set scrolloff=6

" Map <Leader> to ',' and use ';' instead of ':', ';;' instead of ';'
let mapleader=","
nmap ; :
noremap ;; ;

" Wildmenu
set wildmenu
set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox
set wildmode=list:longest,full

" Backspace behavior
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" No status line -- unfortunately this setting is making problems with
" lopen and lclose calls (done by neomake for example)
" set laststatus=0

" Search
set incsearch
set hlsearch

" Carry over indenting from previous line
set autoindent

" Default indentation
set expandtab
set tabstop=4
set shiftwidth=4

" Set textwidth and wrap
set tw=72
set wrap

" Auto and smart indent
set ai
set si

" Show line numbers
set number


"" LOAD PLUGINS -- dein.vim
set runtimepath^=/home/ondra/.config/nvim/dein/repos/github.com/Shougo/dein.vim
call dein#begin(expand('/home/ondra/.config/nvim/dein'))
call dein#add('Shougo/dein.vim')

call dein#add('Shougo/vimproc.vim', { 'build': { 'linux': 'make' } })

" Utility
call dein#add('vim-airline/vim-airline')
call dein#add('scrooloose/nerdtree')

call dein#add('tomtom/tlib_vim')  " snipmate dependency
call dein#add('MarcWeber/vim-addon-mw-utils')  " snipmate dependency
call dein#add('garbas/vim-snipmate')

call dein#add('Shougo/neocomplete')

call dein#add('godlygeek/tabular')
call dein#add('ervandew/supertab')

call dein#add('kien/ctrlp.vim')

" Colors
call dein#add('OndrejSlamecka/dracula-theme-vim')
colorscheme dracula

" General programming
call dein#add('benekastah/neomake')
call dein#add('scrooloose/nerdcommenter')

" Haskell
call dein#add('eagletmt/ghcmod-vim', {'on_ft': ['hs']})
call dein#add('eagletmt/neco-ghc', {'on_ft': ['hs']})
call dein#add('neovimhaskell/haskell-vim', {'on_ft': ['hs']})

" C++
call dein#add('octol/vim-cpp-enhanced-highlight', {'on_ft': ['cpp']})

" Python
call dein#add('vim-scripts/indentpython.vim', {'on_ft': ['py']})

" LaTeX
call dein#add('lervag/vimtex', {'on_ft': ['tex']})

" End plugin definitions
call dein#end()
filetype plugin indent on

" Install not installed plugins on startup
if dein#check_install()
  call dein#install()
endif


"" PLUGIN SETTINGS
" Neomake
let g:neomake_open_list = 2
autocmd! BufWritePost,BufEnter * Neomake

" Airline
let g:airline_powerline_fonts = 1

" NERDTree
map <Leader>n :NERDTreeToggle<CR>

" NERDCommenter
map <silent> <Leader>t :CtrlP()<CR>
noremap <leader>b<space> :CtrlPBuffer<cr>
let g:ctrlp_custom_ignore = '\v[\/]dist$'


"" COMMANDS
" Press F2 will save the file
nmap <F2> :w<CR>
imap <F2> <ESC>:w<CR>i

" q also closes location list (usually opened by neomake)
cabbrev q lclose \| q

" System clipboard copy with control-shift-c
vmap <C-S-C> "+y

" Medium speed scrolling with shift and arrows
nmap <S-Up> 5k
nmap <S-Down> 5j
vmap <S-Up> 5k
vmap <S-Down> 5j
imap <S-Up> <Esc>5ki
imap <S-Down> <Esc>5ji

" Use Q for formatting the current paragraph (or selection)
vmap Q gq
nmap Q gqap

" Create new line, leave insert mode and go line up
nmap <CR> o<Esc>k

" Create a new line after the current line and paste to it
nmap <Leader>p o<ESC>p
nmap <Space> i <Esc>

" <Ctrl-l> redraws the screen and removes any search highlighting
nnoremap <silent> <C-l> :nohl<CR><C-l>

" Switching tabs
nmap <F5> :tabp<CR>
nmap <F6> :tabn<CR>

" Split navigation
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>

" Switching sides in diff mode
if &diff " in diff mode
    nmap <C-h> <C-w><C-w>
    nmap <C-l> <C-w><C-w>
endif

" Write with `sudo` by issuing the :w!! command
cmap w!! w !sudo tee > /dev/null %

" Remove trailing whitespace on save --
" http://stackoverflow.com/a/1618401/2043510
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" Identify the syntax highlighting group used at the cursor using F10
" http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
