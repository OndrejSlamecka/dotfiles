setlocal tabstop=4
setlocal expandtab
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal shiftround

let g:syntastic_cpp_compiler_options = ' -std=c++11 '

let g:neomake_cpp_enabled_makers = ['gcc']
let g:neomake_cpp_gcc_maker = {
    \ 'args': ['-std=c++11']
    \ }
