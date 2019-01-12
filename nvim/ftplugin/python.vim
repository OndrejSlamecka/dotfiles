" Stops overriding of indent settings
let g:python_recommended_style = 0

setlocal noexpandtab
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4

let g:syntastic_python_flake8_args = "--ignore=E127,E128"
let g:neomake_python_enabled_makers = ['flake8']
let g:neomake_python_flake8_maker = {
    \ 'args' : ['--ignore=E127,E128']
    \ }
