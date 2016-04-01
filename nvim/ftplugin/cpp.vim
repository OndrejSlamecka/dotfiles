setlocal tabstop=4
setlocal expandtab
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal shiftround

let g:neomake_cpp_gcc_maker = {
            \ 'args': ['-std=c++11']
            \ }

let g:neomake_cpp_make_maker = {
            \ 'exe': 'make',
            \ 'errorformat': '%f:%l:%c: %m'
            \ }

if filereadable("Makefile")
    let g:neomake_cpp_enabled_makers = ['make']
else
    let g:neomake_cpp_enabled_makers = ['gcc']
endif
