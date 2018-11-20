syntax on
set termguicolors

set number " Show line numbers
set scrolloff=6 " Pad scrolling

" Map <Leader> to ',' and use ';' instead of ':', ';;' instead of ';'
let mapleader=","
map ; :
noremap ;; ;

" Wildmenu
set wildmenu
set wildchar=<S-Tab>
set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox
set wildmode=list:longest,full

" Backspace behavior
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Default indentation
set noexpandtab
set tabstop=4
set shiftwidth=4

" Set textwidth and wrap
set tw=112
set wrap


"" LOAD PLUGINS -- dein.vim
set runtimepath^=/home/$USER/.config/nvim/dein/repos/github.com/Shougo/dein.vim
call dein#begin(expand('~/.cache/dein'))
call dein#add('Shougo/dein.vim')

call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#enabled = 0

call dein#add('scrooloose/nerdtree')
map <Leader>n :NERDTreeToggle<CR>

call dein#add('neomake/neomake')
call neomake#configure#automake('w')

call dein#add('scrooloose/nerdcommenter')
call dein#add('ctrlpvim/ctrlp.vim')
call dein#add('godlygeek/tabular')
call dein#add('tpope/vim-fugitive')

call dein#add('ruanyl/vim-gh-line')
let g:gh_git_remote = "vimtrick"

" Colors -- try https://github.com/Nequo/vim-allomancer when you get bored of this
call dein#add('dracula/vim')
color dracula

" Haskell
call dein#add('eagletmt/ghcmod-vim', {'on_ft': ['hs']})
call dein#add('eagletmt/neco-ghc', {'on_ft': ['hs']})
call dein#add('neovimhaskell/haskell-vim', {'on_ft': ['hs']})

" PureScript
call dein#add('purescript-contrib/purescript-vim', {'on_ft': ['purescript']})
call dein#add('frigoeu/psc-ide-vim', {'on_ft': ['purescript']})

" C++
call dein#add('octol/vim-cpp-enhanced-highlight', {'on_ft': ['cpp']})

" Python
call dein#add('vim-scripts/indentpython.vim', {'on_ft': ['py']})

" Erlang
call dein#add('vim-erlang/vim-erlang-runtime', {'on_ft': ['erl']})
call dein#add('vim-erlang/vim-erlang-tags', {'on_ft': ['erl']})

" Cap'n Proto
call dein#add('cstrahan/vim-capnp', {'on_ft': ['capnp']})
au BufRead,BufNewFile *.capnp set filetype=capnp

" End plugin definitions
call dein#end()
filetype plugin indent on

" Install not installed plugins on startup
if dein#check_install()
  call dein#install()
endif


"" COMMANDS
" Press F2 will save the file
nmap <F2> :w<CR>
imap <F2> <ESC>:w<CR>i

" System clipboard copy
vmap <C-c> "+y

" Go to tag in a new tab
nnoremap <silent><Leader><C-]> <C-w><C-]><C-w>T

" Medium speed scrolling with shift and arrows
nmap <S-Up> 5k
nmap <S-Down> 5j
vmap <S-Up> 5k
vmap <S-Down> 5j
imap <S-Up> <Esc>5ki
imap <S-Down> <Esc>5ji

" <Leader><Space> redraws the screen and removes any search highlighting
nnoremap <Leader><Space> :nohl<CR><C-l>

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

" q also closes quickfix window
" http://stackoverflow.com/a/7477056
aug QFClose
  au!
  au WinEnter * if winnr('$') == 1 && (getbufvar(winbufnr(winnr()), "&buftype") == "quickfix")|q|endif
aug END

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
