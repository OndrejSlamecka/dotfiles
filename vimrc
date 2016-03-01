set nocompatible
filetype plugin indent on
syntax on

" Map <Leader> to ',' and use ';' instead of ':'
nnoremap ; :
let mapleader = ","

" GUI
if has('gui_running')
	set guioptions-=T " no toolbar
	nmap <C-S-V> "+gP
	imap <C-S-V> <ESC><C-V>i
	vmap <C-S-C> "+y
endif

"" PLUGINS
"Vundle -- https://github.com/VundleVim/Vundle.vim
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" Utility
Plugin 'scrooloose/nerdtree'
"Plugin 'kien/ctrlp.vim'

" General programming
Plugin 'scrooloose/syntastic'
"Plugin 'scrooloose/nerdcommenter'

" Colors
Plugin 'zenorocha/dracula-theme', {'rtp': 'vim/'}

" C++
Plugin 'octol/vim-cpp-enhanced-highlight'

" Python
Plugin 'vim-scripts/indentpython.vim'

call vundle#end()

" Dracula theme
hi Search ctermfg=016 guifg=#282a36

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

"" COMMANDS
" Press F2 will save the file
nmap <F2> :w<CR>
imap <F2> <ESC>:w<CR>i

" Press F3 to toggle paste mode
:set pastetoggle=<F3>

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

" Set textwidth and disable wrapping
set tw=72
set nowrap

" Show line numbers
set number

" remove trailing whitespace on save --
" http://stackoverflow.com/a/1618401/2043510
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
