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

" No status line
set laststatus=0

" GUI
if has('gui_running')
    set guioptions-=T " no toolbar
endif


"" LOAD PLUGINS -- dein.vim
set runtimepath^=/home/ondra/.config/nvim/dein/repos/github.com/Shougo/dein.vim
call dein#begin(expand('/home/ondra/.config/nvim/dein'))
call dein#add('Shougo/dein.vim')

call dein#add('Shougo/vimproc.vim', { 'build': { 'linux': 'make' } })

" Utility
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
call dein#add('scrooloose/syntastic')
call dein#add('scrooloose/nerdcommenter')

" Haskell
call dein#add('eagletmt/ghcmod-vim', {'on_ft': ['hs']})
call dein#add('eagletmt/neco-ghc', {'on_ft': ['hs']})
call dein#add('neovimhaskell/haskell-vim', {'on_ft': ['hs']})

" C++
call dein#add('octol/vim-cpp-enhanced-highlight', {'on_ft': ['cpp']})

" Python
call dein#add('vim-scripts/indentpython.vim', {'on_ft': ['py']})

" End plugin definitions
call dein#end()
filetype plugin indent on

" Install not installed plugins on startup
if dein#check_install()
  call dein#install()
endif


"" PLUGIN SETTINGS
" Syntastic post-load setup
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

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

" Press F3 to toggle paste mode
set pastetoggle=<F3>

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

if &diff " in diff mode
    " use F5 or F6 to change sides
    nmap <F5> <C-w><C-w>
    nmap <F6> <C-w><C-w>
else " not in diff mode
    " in normal mode F5 will go to the previous tab
    nmap <F5> :tabp<CR>
    " in normal mode F6 will go to the next tab
    nmap <F6> :tabn<CR>
endif

" Write with `sudo` by issuing the :w!! command
cmap w!! w !sudo tee > /dev/null %

"" DISPLAY & FORMATTING

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