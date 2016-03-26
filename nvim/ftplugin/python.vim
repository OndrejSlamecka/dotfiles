setlocal tabstop=4
setlocal expandtab
setlocal softtabstop=4
setlocal shiftwidth=4

let g:syntastic_python_flake8_args = "--ignore=E127,E128"
let g:neomake_python_enabled_makers = ['flake8']
let g:neomake_python_flake8_maker = {
    \ 'args' : ['--ignore=E127,E128']
    \ }


