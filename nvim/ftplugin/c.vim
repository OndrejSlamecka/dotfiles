setlocal shiftround
setlocal tabstop=4
setlocal shiftwidth=4
setlocal textwidth=80
setlocal noexpandtab

setlocal cindent
setlocal formatoptions=tcqlron
setlocal cinoptions=:0,l1,t0,g0

let g:neomake_c_make_maker = {
            \ 'exe': 'make',
            \ 'errorformat': '%f:%l:%c: %m'
            \ }

if filereadable("Makefile")
    let g:neomake_c_enabled_makers = ['make']
else
    let g:neomake_c_enabled_makers = ['gcc']
endif
