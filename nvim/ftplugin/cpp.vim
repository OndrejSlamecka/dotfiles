setlocal shiftwidth=4
setlocal tabstop=4
setlocal softtabstop=4
setlocal expandtab

setlocal cindent

let g:neomake_cpp_gcc_maker = {
            \ 'args': ['-std=c++17', '-Wall', '-Wextra']
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
