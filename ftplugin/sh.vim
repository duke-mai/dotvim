" Shell filetype plugin

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                         ____  _   _ _____ _     _
"                        / ___|| | | | ____| |   | |
"                        \___ \| |_| |  _| | |   | |
"                         ___) |  _  | |___| |___| |___
"                        |____/|_| |_|_____|_____|_____|
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if exists("b:did_ftplugin")
  fini
en
let b:did_ftplugin = 1

" Lazy-load: shellcheck and shfmt were moved from pack/syntax/start to
" pack/syntax/opt. This file only runs for shell buffers, so it's the
" natural trigger point — same reasoning as ftplugin/python.vim.
packadd shellcheck
packadd shfmt

setl ts=2
setl sts=2
setl shiftwidth=2

" ----------------------------------------------------------------------------
" Maximum width of text that is being inserted set to 88.
" The column 89 is highlighted.
" ----------------------------------------------------------------------------
setl tw=88

" Source: https://gist.github.com/romainl/eabe0fe8c564da1b6cfe1826e1482536
" NOTE: was "aug TooLong" — identical name to the augroup in
" ftplugin/python.vim, which cleared this one's autocmds via `au!`
" depending on file-open order. Renamed unique per filetype. Also fixed the
" pattern from "*" to "<buffer>" (was leaking the 88-column highlight to
" every buffer, not just shell ones) and removed au! (was wiping the
" buffer-local entry from any other already-open shell buffer, since this
" augroup is shared across all shell buffers but the file re-runs once per
" buffer opened -- verified this exact failure mode on python.vim's
" equivalent block before applying the same fix here). The b:did_ftplugin
" guard above already prevents this file running twice for the same buffer.
aug TooLongSh
    au WinEnter,BufEnter <buffer> cal clearmatches()
          \| cal matchadd('ColorColumn', '\%>88v', 100)
aug END

" ----------------------------------------------------------------------------
" Seamlessly treat visual lines as actual lines when moving around.
" ----------------------------------------------------------------------------
nnoremap <buffer> j gj
nnoremap <buffer> k gk

" ----------------------------------------------------------------------------
" Run bash script.
" ----------------------------------------------------------------------------
nnoremap <buffer> <F5>         :!clear && bash %<CR>

" ----------------------------------------------------------------------------
" Perform ShellCheck on bash script.
" ----------------------------------------------------------------------------
nnoremap <buffer> <Leader><F5> :ShellCheck!     <CR>
vnoremap <buffer> <Leader><F5> :ShellCheck!     <CR>

" ----------------------------------------------------------------------------
" source: https://raw.githubusercontent.com/andreafrancia/dot-files/master/.vim/ftplugin/sh.vim
" ----------------------------------------------------------------------------
nnoremap <buffer> <Leader>mf  :call <SID>MakeFunction()              <CR>
vnoremap <buffer> <Leader>rec :call <SID>ExtractCommandInVariable()  <CR>
vnoremap <buffer> <Leader>rea :call <SID>ExtractArgumentInVariable() <CR>
nnoremap <buffer> <Leader>ri  :call <SID>InlineVariableBash()        <CR>

function! s:MakeFunction()
  let name = expand('<cword>')
  execute "normal O".name."() {\<cr>:\<cr>}"
endfunction

" adding . to iskeyword make CTRL-N complete file names
setl iskeyword+=.

function! s:ExtractArgumentInVariable()
    let name = input("Variable name (BASH): ")
    if name == ''
        return
    endif

    let expression = s:GetVisualSelection()
    echom expression
    " Replace selected text with the variable name
    exec "normal! gvc" . '"$' . name . '"'
    " Define the variable on the line above
    exec "normal! O" . name . "=" . '"' . expression . '"'
    " Paste the original selected text to be the variable value
endfunction

function! s:ExtractCommandInVariable()
    let name = input("Variable name (BASH): ")
    if name == ''
        return
    endif

    let expression = s:GetVisualSelection()
    echom expression
    " Replace selected text with the variable name
    exec "normal! gvc" . "echo " . '"$' . name . '"'
    " Define the variable on the line above
    exec "normal! O" . name . "=" . '"$(' . expression . ')"'
    " Paste the original selected text to be the variable value
endfunction
function! s:ExtractCommandInVariableBash()
    let name = input("Variable name (BASH): ")
    if name == ''
        return
    endif

    let expression = s:GetVisualSelection()
    echom expression
    " Replace selected text with the variable name
    exec "normal! gvc" . "echo " . '"$' . name . '"'
    " Define the variable on the line above
    exec "normal! O" . name . "=" . '"$(' . expression . ')"'
    " Paste the original selected text to be the variable value
endfunction

function! s:InlineVariableBash()
    " Copy the variable under the cursor into the 'a' register
    :let l:tmp_a = @a
    :normal "ayiw
    " Delete variable and equals sign
    exec ':.s/' . @a . '=//'
    " Delete the expression into the 'b' register
    :let l:tmp_b = @b
    :normal "bd$
    let expression = @b
    " Remove the first quote
    let expression = substitute(expression, '^"', '', '')
    " Remove the last quote
    let expression = substitute(expression, '"$', '', '')
    " Delete the remnants of the line
    :normal dd
    " Go to the end of the previous line so we can start our search for the
    " usage of the variable to replace. Doing '0' instead of 'k$' doesn't
    " work; I'm not sure why.
    normal k$
    " Find the next occurence of the variable
    exec '/$\<' . @a . '\>'
    " Replace that occurence with the text we yanked
    exec ':.s/$\<' . @a . '\>/' . escape(expression, "/")
    :let @a = l:tmp_a
    :let @b = l:tmp_b
endfunction

" Synopsis:
"   Param: Optional parameter of '1' dictates cut, rather than copy
"   Returns the text that was selected when the function was invoked
"   without clobbering any registers
function! s:GetVisualSelection(...)
  try
    let a_save = @a
    if a:0 >= 1 && a:1 == 1
      normal! gv"ad
    else
      normal! gv"ay
    endif
    return @a
  finally
    let @a = a_save
  endtry
endfunction
