" Author    : Tan Duc Mai <henryfromvietnam@gmail.com>
" Vim plugins configuration

" ----------------------------------------------------------------------------
" NERDTree
" ----------------------------------------------------------------------------
" au VimEnter * NERDTree     " Enable NERDTree on Vim start-up

" Autoclose NERDTree if it's the only open window left
au BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") &&
\ b:NERDTree.isTabTree()) | q | endif

" Have NERDtree show hidden files, but ignore certain files and directories
let NERDTreeShowHidden=1
let NERDTreeRespectWildIgnore = 1
let NERDTreeCaseSensitiveSort = 1
let NERDTreeNaturalSort       = 1
let NERDTreeSortHiddenFirst   = 1
let NERDTreeQuitOnOpen        = 1
let NERDTreeWinPos            = "right"
let NERDTreeWinSize           = 25
let NERDTreeMinimalUI         = 1
let NERDTreeDirArrows         = 1
let NERDTreeAutoDeleteBuffer  = 1


" ----------------------------------------------------------------------------
" Tabman
" ----------------------------------------------------------------------------
" Disable the plugin completely
let g:loaded_tabman = 0

" Override command
let g:tabman_toggle = '<leader>m'
let g:tabman_focus = '<leader>m'

" Configure window layout
let g:tabman_width = 20
let g:tabman_side = 'right'

" Show windows created by plugins, help and quickfix
let g:tabman_specials = 1

" Disable line numbering
let g:tabman_number = 0


" ----------------------------------------------------------------------------
" Unimpaired
" ----------------------------------------------------------------------------
" Toggle cursorcolumn
nn yoc :set cursorcolumn!                              <CR>
au FileType * nn [oc :set cursorcolumn                 <CR>
au FileType * nn ]oc :set nocursorcolumn               <CR>

" Toggle spell
nn yoe :set spell! spelllang=en_au                     <CR>
au FileType * nn [oe :set spell spelllang=en_au        <CR>
au FileType * nn ]oe :set nospell                      <CR>

" Toggle cursorline
nn yol :set cursorline!                                <CR>
au FileType * nn [ol :set cursorline                   <CR>
au FileType * nn ]ol :set nocursorline                 <CR>


" ----------------------------------------------------------------------------
" Easymotion
" ----------------------------------------------------------------------------
let g:Easymotion_do_mapping = 0

" <Bslash>f{char} to move to {char}
map  <Bslash>f <Plug>(easymotion-bd-f)
nmap <Bslash>f <Plug>(easymotion-overwin-f)

" <Bslash><Bslash>f to move to {char}{char}
nmap <Bslash>F <Plug>(easymotion-overwin-f2)

" Move to line
map  <Bslash>L <Plug>(easymotion-bd-jk)
nmap <Bslash>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Bslash>w <Plug>(easymotion-bd-w)
nmap <Bslash>w <Plug>(easymotion-overwin-w)

" hjkl motions: Line and Column motions
map <Bslash>l <Plug>(easymotion-lineforward)
map <Bslash>j <Plug>(easymotion-j)
map <Bslash>k <Plug>(easymotion-k)
map <Bslash>h <Plug>(easymotion-linebackward)

" Keep cursor column when JK motion
let g:EasyMotion_startofline = 0

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" n-character search motion
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
map n <Plug>(easymotion-next)
map N <Plug>(easymotion-prev)


" ----------------------------------------------------------------------------
" Signify
" ----------------------------------------------------------------------------
" Configuration for async update
set updatetime=100

" Enable number column highlighting in addition to using signs by default.
let g:signify_number_highlight = 1


" ----------------------------------------------------------------------------
" Floaterm
" ----------------------------------------------------------------------------
" Configuration
let g:floaterm_gitcommit  = 'floaterm'
let g:floaterm_autoinsert = 1
let g:floaterm_width      = 0.8
let g:floaterm_height     = 0.8
let g:floaterm_wintitle   = 0
let g:floaterm_autoclose  = 1

" Highlight
" Set floaterm window's background to black
" hi Floaterm ctermbg=black
" Set floating window border line colour to cyan, and background to orange
" hi FloatermBorder ctermbg=Black ctermfg=Cyan

" Hide statusline
au! FileType floaterm
au FileType floaterm set laststatus=0 noshowmode noruler
  \| au BufLeave <buffer> set laststatus=2 showmode ruler


" ----------------------------------------------------------------------------
" Goyo
" ----------------------------------------------------------------------------
let g:goyo_width = 83

fu! s:goyo_enter()
  if has('gui_running')
    se fullscreen
    se linespace=7
  elsei exists('$TMUX')
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  end
  aug no_rnu
    au!
    au InsertLeave * set nornu
  aug END
endf

fu! s:goyo_leave()
  if has('gui_running')
    se nofullscreen
    se linespace=0
  elsei exists('$TMUX')
    silent !tmux set status on
  end
  aug toggle_rnu
    au!
    au InsertEnter * setl nornu
    au InsertLeave * setl rnu
  aug END
  " Re-enable Signify.
  SignifyEnableAll
endf

au! User GoyoEnter nested call <SID>goyo_enter()
au! User GoyoLeave nested call <SID>goyo_leave()


" ----------------------------------------------------------------------------
" RainbowParentheses
" ----------------------------------------------------------------------------
let g:rbpt_max = 10
let g:rbpt_colorpairs = [
    \ ['gray',      'HotPink1'],
    \ ['darkred',   'cyan1'],
    \ ['darkcyan',  'RoyalBlue1'],
    \ ['darkgreen', 'yellow1'],
    \ ['darkblue',  'MediumOrchid'],
    \ ['gray',      'DeepSkyBlue1'],
    \ ['darkred',   'DarkOrange1'],
    \ ['darkcyan',  'LimeGreen'],
    \ ['darkgreen', 'goldenrod1'],
    \ ['darkblue',  'brown1'],
    \ ]

au VimEnter * RainbowParenthesesToggleAll
au Syntax   * RainbowParenthesesLoadRound
au Syntax   * RainbowParenthesesLoadSquare
au Syntax   * RainbowParenthesesLoadBraces
au Syntax   * RainbowParenthesesLoadChevrons


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FZF
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'

" Customise fzf colours to match your colourscheme.
let g:fzf_colours =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" An action can be a reference to a function that processes selected lines
fu! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  cope
  cc
endf

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-y': {lines -> setreg('*', join(lines, "\n"))}}

let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }

" Hide statusline
au! FileType fzf set laststatus=0 noshowmode noruler
  \| au BufLeave <buffer> set laststatus=2 showmode ruler

com! -bang DotVim call fzf#vim#files('$HOME/.vim/', <bang>0)
com! -bang DotFiles call fzf#vim#files('$HOME/.files/', <bang>0)
com! -bang HomeDir call fzf#vim#files('$HOME/', <bang>0)
com! -bang DictDir call fzf#vim#files('/usr/share/dict/', <bang>0)


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Supertab
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enhanced longest match support.
let g:SuperTabLongestEnhanced = 1

" Use tab to scroll down the list.
let g:SuperTabDefaultCompletionType = "<C-N>"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Undotree
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure window layout
let g:undotree_CustomUndotreeCmd  = 'topleft vertical 22 new'
let g:undotree_CustomDiffpanelCmd = 'botright 7 new'

" E.g. d instead of day
let g:undotree_ShortIndicators = 1

" Hide 'Press ? for help'
let g:undotree_HelpLine = 0


" ----------------------------------------------------------------------------
" Flake8
" ----------------------------------------------------------------------------
" let g:flake8_show_in_gutter=1
" let g:flake8_show_in_file=1

" Run Flake8 check every time I write a Python file
" au BufWritePost *.py call flake8#Flake8()


" ----------------------------------------------------------------------------
" Thesaurus Query
" ----------------------------------------------------------------------------
let g:tq_online_backends_timeout = 0.4
let g:tq_truncation_on_definition_num = 2
let g:tq_truncation_on_syno_list_size = 20


" ----------------------------------------------------------------------------
" GitGutter
" ----------------------------------------------------------------------------
let g:gitgutter_preview_win_floating = 1


" ----------------------------------------------------------------------------
" Vimdent
" ----------------------------------------------------------------------------
let g:vindent_motion_OO_prev   = '[=' " jump to prev block of same indent.
let g:vindent_motion_OO_next   = ']=' " jump to next block of same indent.
let g:vindent_motion_more_prev = '[+' " jump to prev line with more indent.
let g:vindent_motion_more_next = ']+' " jump to next line with more indent.
let g:vindent_motion_less_prev = '[-' " jump to prev line with less indent.
let g:vindent_motion_less_next = ']-' " jump to next line with less indent.
let g:vindent_motion_diff_prev = '[;' " jump to prev line with different indent.
let g:vindent_motion_diff_next = '];' " jump to next line with different indent.
let g:vindent_motion_XX_ss     = '[p' " jump to start of the current block scope.
let g:vindent_motion_XX_se     = ']p' " jump to end   of the current block scope.
let g:vindent_object_XX_ii     = 'ii' " select current block.
let g:vindent_object_XX_ai     = 'ai' " select current block + one extra line  at beginning.
let g:vindent_object_XX_aI     = 'aI' " select current block + two extra lines at beginning and end.
let g:vindent_jumps            = 1    " make vindent motion count as a |jump-motion| (works with |jumplist|).
