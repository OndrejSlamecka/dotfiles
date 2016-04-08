let g:vimtex_view_method = 'zathura'
let g:vimtex_latexmk_progname = 'nvr'

" === conceal ===
set conceallevel=2

" a = conceal accents/ligatures
" d = conceal delimiters
" g = conceal Greek
" m = conceal math symbols
" s = conceal superscripts/subscripts<Paste>
let g:tex_conceal= 'adgms'

hi link texGreek Normal
hi! link Conceal Normal
