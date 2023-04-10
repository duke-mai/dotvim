" Markdown filetype plugin

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"            __  __    _    ____  _  ______   _____        ___   _
"           |  \/  |  / \  |  _ \| |/ /  _ \ / _ \ \      / / \ | |
"           | |\/| | / _ \ | |_) | ' /| | | | | | \ \ /\ / /|  \| |
"           | |  | |/ ___ \|  _ <| . \| |_| | |_| |\ V  V / | |\  |
"           |_|  |_/_/   \_\_| \_\_|\_\____/ \___/  \_/\_/  |_| \_|
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if exists("b:did_ftplugin")
  fini
end

ru! ftplugin/html.vim ftplugin/html_*.vim ftplugin/html/*.vim

" Enable plugin
packadd gfm-syntax
packadd limelight

set ts=4
set shiftwidth=4
set sts=4
setl tw=80

setl comments=fb:*,fb:-,fb:+,n:> commentstring=<!--%s-->
setl formatoptions+=tcqln formatoptions-=r formatoptions-=o
setl formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^\\s*[-*+]\\s\\+\\\|^\\[^\\ze[^\\]]\\+\\]:\\&^.\\{4\\}

hi Title cterm=bold

" ----------------------------------------------------------------------------
" goyo.vim + limelight.vim
" ----------------------------------------------------------------------------
let g:limelight_paragraph_span = 1
let g:limelight_priority = -1

fu! s:enable_limelight()
  Limelight
endf

fu! s:disable_limelight()
  Limelight!
  so $MYVIMRC
endf

au! User GoyoEnter nested call <SID>enable_limelight()
au! User GoyoLeave nested call <SID>disable_limelight()

" ----------------------------------------------------------------------------
" Tabular
" ----------------------------------------------------------------------------
" Call the :Tabularize command each time a | character is inserted
ino <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a
fu! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    norm! 0
    cal search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  end
endf

" ----------------------------------------------------------------------------
" Format paragraph (selected or not) to 80 character lines
" ----------------------------------------------------------------------------
nn fp gqap     :ec 'Paragraph Formatted !' <CR>
xn fp gqa<Esc> :ec 'Paragraph Formatted !' <CR>


" ----------------------------------------------------------------------------
" Seamlessly treat visual lines as actual lines when moving around
" ----------------------------------------------------------------------------
nn j gj
nn k gk


" ----------------------------------------------------------------------------
" Create and format table of contents
" ----------------------------------------------------------------------------
nn <F5> :GenTocGFM<CR>:%s/* \[/1. \[/g<CR>gqap


" ----------------------------------------------------------------------------
" Align tables
" ----------------------------------------------------------------------------
vn <F5> :Tabularize /\|<CR>


" ----------------------------------------------------------------------------
" Convert md to pdf, html, ppt filetype
" ----------------------------------------------------------------------------
" Requirements: $ sudo apt install pandoc, texlive-latex-extra

nn PDF :!clear && echo 'Start Generating The PDF Version...' &&
      \ pandoc % -t beamer -o %.pdf<CR>
      \ :ec 'The PDF Version Is Ready !'<CR>

" Beautiful display on the web
nn HTML :!clear && echo 'Start Generating The HTML Version...' &&
      \ pandoc -t slidy -s % -o %.html<CR>
      \ :ec 'The HTML Version Is Ready !'<CR>

" Not very useful since the formatting is not good
nn PPT :!clear && echo 'Start Generating The PPT Version...' &&
      \ pandoc % -o %.pptx<CR>
      \ :ec 'The PPT Version Is Ready !'<CR>


" ----------------------------------------------------------------------------
" Abbreviations for the above conversion
" ----------------------------------------------------------------------------
ia abbr <Esc>ggO---<CR>title:<CR>- My Presentation<CR>author:<CR>- Tan Duc Mai<CR>theme:<CR>- Copenhagen<CR>date:<CR>- December 29th, 2021<CR>---<CR><ESC>


" ----------------------------------------------------------------------------
" Jump to next heading
" ----------------------------------------------------------------------------
" Source: https://gist.github.com/romainl/ac63e108c3d11084be62b3c04156c263
fu! s:JumpToNextHeading(direction, count)
    let col = col(".")

    silent exe a:direction == "up" ? '?^#' : '/^#'

    if a:count > 1
        silent exe "normal! " . repeat("n", a:direction == "up" && col != 1 ? a:count : a:count - 1)
    end

    silent exe "normal! " . col . "|"

    unlet col
endf

nn <buffer> <silent> ]] :<C-u>cal <SID>JumpToNextHeading("down", v:count1)<CR>zz
nn <buffer> <silent> [[ :<C-u>cal <SID>JumpToNextHeading("up", v:count1)<CR>zz
