" Vim filetype plugin

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                           __     _____ __  __
"                           \ \   / /_ _|  \/  |
"                            \ \ / / | || |\/| |
"                             \ V /  | || |  | |
"                              \_/  |___|_|  |_|
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
" ftplugin/tex.vim, so whichever of the two loaded last would clear the
" other's column-highlight autocmds via au!. Renamed unique per filetype.
" au! also removed and pattern scoped to <buffer> — same multi-buffer
" wipeout / cross-filetype leak bug found and fixed in python.vim, sh.vim,
" and tex.vim's equivalent blocks; the guard above already prevents this
" file running twice for the same buffer, so au! was never needed here.
aug TooLongVim
    au WinEnter,BufEnter <buffer> cal clearmatches()
          \| cal matchadd('ColorColumn', '\%>80v', 100)
aug END
