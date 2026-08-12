" Author    : Duke Mai <henryfromvietnam@gmail.com>
" Vim plugins configuration

" ----------------------------------------------------------------------------
" NERDTree {{{
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

" }}}
" ----------------------------------------------------------------------------
" Unimpaired {{{
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

" }}}
" ----------------------------------------------------------------------------
" Easymotion {{{
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
" FIXED: was `map /` (Normal + Visual + Operator-pending). That silently
" broke standard Visual-mode search (`v/pattern`) and any operator-pending
" use of `/` outside the explicit `omap` below, by routing them through
" EasyMotion instead of Vim's native incremental search. Restricting to
" `nmap` keeps `/` doing plain Vim search everywhere except Normal mode,
" where EasyMotion's overlay is the intended enhancement.
nmap / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
" FIXED: was `map n`/`map N` (also Visual + Operator-pending); restricted to
" `nmap` so Visual-mode repeat-search (`gv` selections, `d n` etc.) is
" unaffected and keeps standard Vim behaviour.
nmap n <Plug>(easymotion-next)
nmap N <Plug>(easymotion-prev)

" }}}
" ----------------------------------------------------------------------------
" Signify {{{
" ----------------------------------------------------------------------------
" Configuration for async update
set updatetime=100

" Enable number column highlighting in addition to using signs by default.
let g:signify_number_highlight = 1

" }}}
" ----------------------------------------------------------------------------
" Floaterm {{{
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

" Lazy-load: floaterm was moved from pack/plugins/start to pack/plugins/opt.
" This stub loads the real plugin, which immediately redefines
" :FloatermToggle with its own command — the second segment below then
" resolves to that new definition, not back to this stub, so it does not
" recurse. The \t mappings later in vimrc are unchanged; they just call
" :FloatermToggle as before.
command! FloatermToggle packadd floaterm | FloatermToggle

" }}}
" ----------------------------------------------------------------------------
" Goyo {{{
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

" }}}
" ----------------------------------------------------------------------------
" RainbowParentheses {{{
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

" }}}
" ----------------------------------------------------------------------------
" FZF {{{
" ----------------------------------------------------------------------------
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

" }}}
" ----------------------------------------------------------------------------
" Supertab {{{
" ----------------------------------------------------------------------------
" Enhanced longest match support.
let g:SuperTabLongestEnhanced = 1

" Use tab to scroll down the list.
let g:SuperTabDefaultCompletionType = "<C-N>"

" }}}
" ----------------------------------------------------------------------------
" Undotree {{{
" ----------------------------------------------------------------------------
" Configure window layout
let g:undotree_CustomUndotreeCmd  = 'topleft vertical 22 new'
let g:undotree_CustomDiffpanelCmd = 'botright 7 new'

" E.g. d instead of day
let g:undotree_ShortIndicators = 1

" Hide 'Press ? for help'
let g:undotree_HelpLine = 0

" Lazy-load: mundo (this plugin's config vars above use its original
" 'undotree' naming) was moved from pack/file-system/start to
" pack/file-system/opt. This stub loads the real plugin before running
" the actual command, so <Leader>u later in vimrc keeps working unchanged.
" Same non-recursive packadd-then-run pattern as FloatermToggle above.
command! MundoToggle packadd mundo | MundoToggle

" }}}
" ----------------------------------------------------------------------------
" Thesaurus Query {{{
" ----------------------------------------------------------------------------
let g:tq_online_backends_timeout = 0.4
let g:tq_truncation_on_definition_num = 2
let g:tq_truncation_on_syno_list_size = 20

" }}}
" ----------------------------------------------------------------------------
" GitGutter {{{
" ----------------------------------------------------------------------------
let g:gitgutter_map_keys = 0
let g:gitgutter_preview_win_floating = 1
nmap ghs <Plug>(GitGutterStageHunk)
nmap ghu <Plug>(GitGutterUndoHunk)
nmap ghp <Plug>(GitGutterPreviewHunk)
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

" }}}
" ----------------------------------------------------------------------------
" Vimdent {{{
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

" }}}
" ----------------------------------------------------------------------------
" Maximizer {{{
" ----------------------------------------------------------------------------
let g:maximizer_set_default_mapping = 0

" }}}
" ----------------------------------------------------------------------------
" Vimwiki {{{
" ----------------------------------------------------------------------------
" NOTE: left eager (pack/writing/start), deliberately NOT moved to opt/
" despite being one of the heavier plugins here. vimwiki's own filetype
" detection (matching *.wiki files) lives in ITS OWN ftdetect/ directory —
" Vim only scans an opt/ package's ftdetect scripts once that package has
" already been packadd-ed. Lazy-loading it correctly needs this repo's own
" `BufRead *.wiki` hook to packadd the plugin BEFORE its native detection
" would normally run, then re-fire detection for the buffer already open.
" That pattern is only verifiable against vimwiki's actual ftdetect/ftplugin
" behaviour, which isn't available in this sandbox (submodule content isn't
" included in a zip export). Rather than ship an unverified change that
" could silently break .wiki file handling, this is left as-is. If you want
" to revisit it: move to pack/writing/opt/vimwiki, then add
"   au BufNewFile,BufRead *.wiki ++once packadd vimwiki | doautocmd BufRead
" and test opening a .wiki file actually gets filetype=wiki applied.
" let g:vimwiki_folding = 'expr' " Enable folding based on the syntax
let g:vimwiki_listsyms = '✗○◐●✓' " Use custom symbols for todo lists
let g:vimwiki_html_header_numbering = 1 " Enable header numbering in HTML
let g:vimwiki_html_use_css = 1 " Enable CSS for HTML
let g:vimwiki_html_css_name = '~/vimwiki/style.css' " Use a custom CSS file
let g:vimwiki_diary_rel_path = 'diary/' " Set the diary subdirectory
let g:vimwiki_diary_header = 'Diary: %d %b %Y' " Set the diary header format
let g:vimwiki_diary_link_count = 7 " Set the number of diary links to show
let g:vimwiki_conceal_brackets = 1 " Conceal the brackets around links
let g:vimwiki_camel_case = 0 " Disable WikiWord auto-links
let g:vimwiki_valid_html_tags = 'b,i,s,u,sub,sup,kbd,br,hr' " Set the valid HTML tags
let g:vimwiki_global_ext = 0 " Disable global VimWiki commands

"}}}
" ----------------------------------------------------------------------------
" Colorizer (lazy) {{{
" ----------------------------------------------------------------------------
" Moved from pack/colours/start to pack/colours/opt: colorizer scans every
" buffer for colour codes to highlight, which is only useful in CSS-family
" files. Loading it unconditionally at startup costs time on every buffer,
" including source files with no colour codes at all.
augroup LazyColorizer
  au!
  au FileType css,html,scss,less,sass,javascript packadd colorizer
augroup END

"}}}
" ----------------------------------------------------------------------------
" awesome-vim-colorschemes (lazy) {{{
" ----------------------------------------------------------------------------
" Moved from pack/colours/start to pack/colours/opt: this bundle parses
" ~80 colour scheme files at startup, none of which are the active
" gruvbox-material theme. :Colors loads the bundle plus the scheme browser
" on demand instead.
command! Colors packadd awesome-vim-colorschemes | packadd colorSchemeExplorer
      \ | ColorSchemeExplorer

"}}}
