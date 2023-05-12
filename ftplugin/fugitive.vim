" Fugitive filetype plugin

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                 _____ _   _  ____ ___ _____ _____     _______
"                |  ___| | | |/ ___|_ _|_   _|_ _\ \   / / ____|
"                | |_  | | | | |  _ | |  | |  | | \ \ / /|  _|
"                |  _| | |_| | |_| || |  | |  | |  \ V / | |___
"                |_|    \___/ \____|___| |_| |___|  \_/  |_____|
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Hide statusline fugitive
setl laststatus=0 noshowmode noruler
  \| au BufLeave <buffer> setl laststatus=2 showmode ruler

" Quick push during a commit window
com! Gpush :!clear && echo 'Wait for the local commits to be pushed to GitHub
      \ ...\n--------------------' && git push

" Auto destroy Fugitive buffers
" http://vimcasts.org/episodes/fugitive-vim-browsing-the-git-object-database/
autocmd BufReadPost fugitive://* setl bufhidden=delete
