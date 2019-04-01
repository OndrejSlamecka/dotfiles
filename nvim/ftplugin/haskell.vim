" Derived from a great guide by Stephen Diehl
" http://www.stephendiehl.com/posts/vim_2016.html

setlocal expandtab
setlocal softtabstop=2
setlocal shiftwidth=2

" Conceal
setlocal conceallevel=2
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


" == neco-ghc ==

let g:haskellmode_completion_ghc = 0
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

" == intero ==

" Automatically reload on save
au BufWritePost *.hs InteroReload

" Lookup the type of expression under the cursor
nmap <silent> <leader>t <Plug>InteroGenericType
nmap <silent> <leader>T <Plug>InteroType
" Insert type declaration
nnoremap <silent> <leader>ni :InteroTypeInsert<CR>
" Show info about expression or type under the cursor
nnoremap <silent> <leader>i :InteroInfo<CR>

" Open/Close the Intero terminal window
nnoremap <silent> <leader>nn :InteroOpen<CR>
nnoremap <silent> <leader>nh :InteroHide<CR>

" Reload the current file into REPL
nnoremap <silent> <leader>nf :InteroLoadCurrentFile<CR>
" Jump to the definition of an identifier
nnoremap <silent> <leader>ng :InteroGoToDef<CR>
" Evaluate an expression in REPL
nnoremap <silent> <leader>ne :InteroEval<CR>

" Start/Stop Intero
nnoremap <silent> <leader>ns :InteroStart<CR>
nnoremap <silent> <leader>nk :InteroKill<CR>

" Reboot Intero, for when dependencies are added
nnoremap <silent> <leader>nr :InteroKill<CR> :InteroOpen<CR>

" Managing targets
" Prompts you to enter targets (no silent):
nnoremap <leader>nt :InteroSetTargets<CR>
