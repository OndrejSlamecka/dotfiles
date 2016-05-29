" === vimtex ===

" The following features require zathura to be opened by \ll
" To locate text in zathura from nvim do \lv,
" to locate text from zathura in nvim do Ctrl-Click

let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'zathura'
let g:vimtex_latexmk_progname = 'nvr'
let g:vimtex_latexmk_continuous = 1

" === neomake ===
let g:neomake_tex_chktex_maker = {
            \ 'args': ['-n 8']
            \ }

let g:neomake_tex_enabled_makers = ['chktex']

" === conceal ===
set conceallevel=2

" a = conceal accents/ligatures
" d = conceal delimiters
" g = conceal Greek
" m = conceal math symbols
" s = conceal superscripts/subscripts
let g:tex_conceal= 'adgms'

hi link texGreek Normal
hi! link Conceal Normal
