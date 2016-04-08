" Derived from a great guide by Stephen Diehl
" http://www.stephendiehl.com/posts/vim_2016.html

setlocal expandtab
setlocal softtabstop=2
setlocal shiftwidth=2

" Conceal
set conceallevel=2
hi link hsNiceOperator Operator
hi! link Conceal Operator
syntax match hsNiceOperator /\s\.\s/ms=s+1,me=e-1 conceal cchar=∘
syntax match hsNiceOperator "\\\ze[[:alpha:][:space:]_([]" conceal cchar=λ


" == haskell-vim ==
let g:haskell_enable_quantification = 1
let g:haskell_enable_recursivedo = 1
let g:haskell_enable_arrowsyntax = 1
let g:haskell_enable_pattern_synonyms = 1
let g:haskell_enable_typeroles = 1
let g:haskell_enable_static_pointers = 1
let g:haskell_classic_highlighting = 1


" == ghc-mod ==
map <silent> tq :GhcModType<CR>
map <silent> tw :GhcModTypeInsert<CR>
map <silent> te :GhcModTypeClear<CR>
map <silent> ts :GhcModSplitFunCase<CR>


" == supertab ==

let g:SuperTabDefaultCompletionType = '<c-x><c-o>'

if has("gui_running")
  imap <c-space> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
else " no gui
  if has("unix")
    inoremap <Nul> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
  endif
endif

let g:haskellmode_completion_ghc = 1
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

" == neco-ghc ==

let g:haskellmode_completion_ghc = 1
setlocal omnifunc=necoghc#omnifunc


" == tabular ==

let g:haskell_tabular = 1

vmap a= :Tabularize /=<CR>
vmap a; :Tabularize /::<CR>
vmap a- :Tabularize /-><CR>


" == pointfree <-> pointful conversion"
function! Pointfree()
  call setline('.', split(system('pointfree '.shellescape(join(getline(a:firstline, a:lastline), "\n"))), "\n"))
endfunction
vnoremap <silent> <leader>h. :call Pointfree()<CR>

function! Pointful()
  call setline('.', split(system('pointful '.shellescape(join(getline(a:firstline, a:lastline), "\n"))), "\n"))
endfunction
vnoremap <silent> <leader>h> :call Pointful()<CR>
