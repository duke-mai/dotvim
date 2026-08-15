" SQL filetype plugin

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               ____   ___  _
"                              / ___| / _ \| |
"                              \___ \| | | | |
"                               ___) | |_| | |___
"                              |____/ \__\_\_____|
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if exists("b:did_ftplugin")
  fini
en
let b:did_ftplugin = 1

setl ts=4
setl sts=4
setl shiftwidth=4
setl commentstring=--\ %s

" Seamlessly treat visual lines as actual lines when moving around.
nnoremap <buffer> j gj
nnoremap <buffer> k gk
