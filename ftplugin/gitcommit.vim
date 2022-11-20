" Gitcommit filetype plugin

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"               ____ ___ _____ ____ ___  __  __ __  __ ___ _____
"              / ___|_ _|_   _/ ___/ _ \|  \/  |  \/  |_ _|_   _|
"             | |  _ | |  | || |  | | | | |\/| | |\/| || |  | |
"             | |_| || |  | || |__| |_| | |  | | |  | || |  | |
"              \____|___| |_| \____\___/|_|  |_|_|  |_|___| |_|
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable spell checking for gitcommit
setl spell spl=en_au

" Maximum width of text that is being inserted set to 72.
" The column 73 is highlighted.
setl tw=72

" Source: https://gist.github.com/romainl/eabe0fe8c564da1b6cfe1826e1482536
aug TooLong
    au!
    au WinEnter,BufEnter * cal clearmatches()
          \| cal matchadd('ColorColumn', '\%>72v', 100)
aug END

" Instead of reverting the cursor to the last position in the buffer
" set it to the first line when editing a git commit message
au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
