" NOTE: I am using neovim, this is just a basic .vimrc I am using for
" quick setups

set nocompatible
syntax on

" INTERFACE
colorscheme desert

" Map <Leader> to ',' and use ';' instead of ':'
nnoremap ; :
let mapleader = ","

" Backspace behavior
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

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

" Remove trailing whitespace on save --
" http://stackoverflow.com/a/1618401/2043510
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
