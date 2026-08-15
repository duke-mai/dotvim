" Latex filetype plugin

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                       _        _  _____ _______  __
"                       | |      / \|_   _| ____\ \/ /
"                       | |     / _ \ | | |  _|  \  /
"                       | |___ / ___ \| | | |___ /  \
"                       |_____/_/   \_\_| |_____/_/\_\
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if exists("b:did_ftplugin")
  fini
en
let b:did_ftplugin = 1

setl ts=2
setl sts=2
setl shiftwidth=2
setl nolisp
setl nosi
setl foldmethod=marker

" Maximum width of text that is being inserted set to 80.
" The column 81 is highlighted.
setl tw=80

" Source: https://gist.github.com/romainl/eabe0fe8c564da1b6cfe1826e1482536
" NOTE: was "aug TooLong" — identical bare name to the augroup in
" ftplugin/vim.vim, so whichever of the two loaded last would clear the
" other's column-highlight autocmds via au!. Renamed unique per filetype,
" same fix as applied to python.vim/sh.vim in an earlier pass. au! also
" removed — this augroup is shared across all tex buffers but the file
" re-runs once per buffer opened, so au! would wipe the buffer-local entry
" from any other already-open tex buffer. The b:did_ftplugin guard above
" already prevents this file running twice for the same buffer.
aug TooLongTex
    au WinEnter,BufEnter <buffer> cal clearmatches()
          \| cal matchadd('ColorColumn', '\%>80v', 100)
aug END

" Vimtex
let g:tex_flavor='latex'
" let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
setl conceallevel=1
let g:tex_conceal='abdmg'
