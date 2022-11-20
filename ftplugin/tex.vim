" Latex filetype plugin

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                       _        _  _____ _______  __
"                       | |      / \|_   _| ____\ \/ /
"                       | |     / _ \ | | |  _|  \  /
"                       | |___ / ___ \| | | |___ /  \
"                       |_____/_/   \_\_| |_____/_/\_\
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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
aug TooLong
    au!
    au WinEnter,BufEnter * cal clearmatches()
          \| cal matchadd('ColorColumn', '\%>80v', 100)
aug END

" Vimtex
let g:tex_flavor='latex'
" let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

