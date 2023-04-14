" Author    : Tan Duc Mai <tan.duc.work@gmail.com>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"               ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
"               ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
"               ██║   ██║██║██╔████╔██║██████╔╝██║
"               ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║
"                ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"                 ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Load the documentation for all the plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
packloadall          " Load all plugins
silent! helptags ALL " Load help for all plugins


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Load word files
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
so ~/.vim/dictionary/wordlist.vim
so ~/.vim/dictionary/abbreviation.vim
set spf=~/.vim/dictionary/en.utf-8.add
set dictionary+=~/.vim/dictionary/en_US.txt
set dictionary+=~/.vim/dictionary/british-english-insane.txt
set dictionary+=~/.vim/dictionary/english_words/words.txt
set dictionary+=~/.vim/dictionary/moby_data/acronyms.txt
set dictionary+=~/.vim/dictionary/moby_data/names.txt
set dictionary+=~/.vim/dictionary/moby_data/names-f.txt
set dictionary+=~/.vim/dictionary/moby_data/names-m.txt
set dictionary+=~/.vim/dictionary/moby_data/oftenmis.txt
set dictionary+=~/.vim/dictionary/moby_data/places.txt


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Reload quote files
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au BufWinLeave ~/.files/doc/quotes/technology :!strfile technology
au BufWinLeave ~/.files/doc/quotes/inspiration :!strfile inspiration


" ============================================================================
" ENVIRONMENT {{{
" ============================================================================
" Identify platform {
silent fu! OSX()
    retu has('macunix')
endf
silent fu! LINUX()
    retu has('unix') && !has('macunix') && !has('win32unix')
endf
silent fu! WINDOWS()
    retu  (has('win32') || has('win64'))
endf
" }

" Basics {
se nocompatible        " Must be first line
if !WINDOWS()
    se shell=/bin/sh
en
" }

" Windows Compatible {
" On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
" across (heterogeneous) systems easier.
if WINDOWS()
  se runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.files/after
en
" }

" Arrow Key Fix {
" https://github.com/spf13/spf13.files/issues/780
if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
    inoremap <silent> <C-[>OC <RIGHT>
en
" }

" }}}
" ============================================================================
" GUI RELATED {{{
" ============================================================================

" ----------------------------------------------------------------------------
" Set font according to system
" ----------------------------------------------------------------------------
if has("mac") || has("macunix")
  set gfn=IBM\ Plex\ Mono:h14,Hack:h14,Source\ Code\ Pro:h15,Menlo:h15
elseif has("win16") || has("win32")
  set gfn=IBM\ Plex\ Mono:h14,Source\ Code\ Pro:h12,Bitstream\ Vera\ Sans\ Mono:h11
elseif has("gui_gtk2")
  set gfn=IBM\ Plex\ Mono\ 14,:Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has("linux")
  set gfn=IBM\ Plex\ Mono\ 14,:Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has("unix")
  set gfn=Monospace\ 11
endif


" ----------------------------------------------------------------------------
" Disable scrollbars (real hackers don't use scrollbars for navigation!)
" ----------------------------------------------------------------------------
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

" }}}
" ============================================================================
" GENERAL CONFIGURATION OPTIONS {{{
" ============================================================================

if has('cmdline_info')
  se ru                   " Show the ruler
  se rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
  se sc                 " Show partial commands in status line and
                          " Selected characters/lines in visual mode
en

" Faster redrawing
set tf

" Allow backspacing over indention, line breaks and insertion start.
set backspace=indent,eol,start
set history=1000 " Set bigger history of executed commands.
set smd          " Show current mode at the bottom.
" Automatically re-read files if unmodified inside Vim.
set ar
" Manage multiple buffers effectively: the current buffer can be “sent” to
" the background without writing to disk. When a background buffer become
" current again, marks and undo-history are remembered.
set hid

let mapleader="\<Space>"  " Map the leader key to a spacebar.


" ----------------------------------------------------------------------------
" User Interface Options
" ----------------------------------------------------------------------------
set ls=2      " Always display the status bar.
set noeb      " Disable beep on errors.
set vb        " Flash screen instead of beeping on errors.
set mouse=a   " Enable mouse for scrolling and resizing.
set cul nocuc " Enable cursorline, disable cursorcolumn
set nu rnu    " Enable (relative) number
set sb spr    " Split below / right
" Set the window’s title, reflecting the file currently being edited.
set title
" Maximum number of tab pages that can be opened from the command line.
set tpm=15
set tags+=tags;

" ----------------------------------------------------------------------------
" Wildmenu completion
" ----------------------------------------------------------------------------
set wmnu                  " Enable auto completion menu after <TAB>
set wim=longest,list,full " Make wildmenu behave akin to Bash completion

set wig+=.hg,.git,.svn                    " Version control
set wig+=*.aux,*.out,*.toc,*.log,*.idx    " LaTeX intermediate files
set wig+=*_aux,*.glg,*.glo,*.gls,*.ist    " LaTeX intermediate files
set wig+=*.nlo,*.nls,*.pdf,*.bbl,*.dvi    " still LaTeX intermediate files
set wig+=*.ilg,*.fdb_latexmk,*.synctex.gz " $(B!D(B LaTeX intermediate files
set wig+=*.blg,*.ind                      " $(B!D!D!D(B LaTeX intermediate files
set wig+=*.hi                             " Haskell linker files
set wig+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wig+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wig+=*.spl                            " compiled spelling word lists
set wig+=*.sw?                            " Vim swap files
set wig+=*.DS_Store                       " OSX bullshit

set wig+=*.luac                           " Lua byte code

set wig+=migrations                       " Django migrations
set wig+=*.pyc                            " Python byte code

set wig+=*.orig                           " Merge resolution files

" Clojure/Leiningen
set wig+=classes
set wig+=lib

" Better Completion
set cot=longest,menuone,preview,noinsert,noselect
set ofu=syntaxcomplete#Complete
set complete=.,w,b,u,t


" ----------------------------------------------------------------------------
" Register / Clipboard
" ----------------------------------------------------------------------------
if has('clipboard')
  if has('unnamedplus')  " When possible use + register for copy-paste
    se clipboard=unnamed,unnamedplus
  el         " On mac and Windows, use * register for copy-paste
    se clipboard=unnamed
  en
en

" Prevent x and the delete key from overriding what's in the clipboard
nn x "_x
nn X "_x
nn <Del> "_x

" Prevent selecting and pasting from overwriting what you originally copied
xn p pgvy


" ----------------------------------------------------------------------------
" Indentation options
" ----------------------------------------------------------------------------
set ai           " New lines inherit the indentation of previous lines
filet on         " Enable type file detection
filet plugin on  " Enable and load plugin for the detected file type
filet indent on  " Load an indent file for the detected file type
set et           " Use space characters instead of tabs
set sta
set wrap
set nolisp
set nosi
set lbr
set tf
set lz
set nojoinspaces
set bri
set sr


" ----------------------------------------------------------------------------
" Search options:
" ----------------------------------------------------------------------------
set incsearch    " Find the next match as we type the search
set nohlsearch   " Highlight searches by default
set smartcase    " . . . unless you type a capital
set showmatch    " Show matching words during a search
set noignorecase " Do not ignore capital letters during search


" ----------------------------------------------------------------------------
" Text rendering options
" ----------------------------------------------------------------------------
set encoding=utf-8  " Use an encoding that supports Unicode
" Wrap lines at convenient points.
" Avoid wrapping a line in the middle of a word
set linebreak
" The number of screen lines to keep above and below the cursor
set scrolloff=3
" The number of screen columns to keep to the left and right of the cursor
set sidescrolloff=5


" ----------------------------------------------------------------------------
" Miscellaneous Options:
" ----------------------------------------------------------------------------
" Display a confirmation dialogue when closing an unsaved file
set confirm
" Ignore files mode lines; use vimrc configurations instead
set nomodeline
" Interpret octal as decimal when incrementing numbers
set nrformats-=octal


" ----------------------------------------------------------------------------
" Set up persistent undo across all files
" ----------------------------------------------------------------------------
if has("persistent_undo")
  let undo_dir = expand('/tmp/.undo/')

  " Create undo directory if possible and does not exist yet
  if !isdirectory(undo_dir) && getftype(undo_dir) == "" && exists("*mkdir")
    call mkdir(undo_dir, "p", 0700)
  en

  let &udir = undo_dir
  set undofile
  set ul=1000        " Maximum number of changes that can be undone
  set ur=10000       " Maximum number lines to save for undo on a buffer reload
en


" ----------------------------------------------------------------------------
" Enable backup directory, but disable swap dir
" ----------------------------------------------------------------------------
" Create backup directory if possible and does not exist yet
let backup_dir = expand('/tmp/.backup/')
if !isdirectory(backup_dir) && getftype(backup_dir) == "" && exists("*mkdir")
  call mkdir(backup_dir, "p", 0700)
endif

set bdir=/tmp/.backup/ " backups

" Disable swap file
set noswapfile

" }}}
" ==============================================================================
" TEMPLATES & CUSTOM VIM FILETYPE SETTINGS {{{
" ==============================================================================

if has("autocmd")
  aug templates
    au BufNewFile *.sh 0r ~/.vim/template/sh.template
    au BufNewFile *.html 0r ~/.vim/template/html.template
    au BufNewFile *.py 0r ~/.vim/template/python.template
  aug END
en

" Create a file in ftplugin/filetype.vim for specific settings
if has("autocmd")
  aug filetypes
    au BufRead,BufNewFile,BufReadPost *.template   se ft=text
    au BufRead,BufNewFile,BufReadPost *.md         se ft=markdown
    au BufRead,BufNewFile,BufReadPost *.jade       se ft=pug
    au BufRead,BufNewFile,BufReadPost *.pug        se ft=pug
    au BufRead,BufNewFile,BufReadPost *.coffee     se ft=coffee
    au BufEnter ~/.files/git/gitconfig             se ft=gitconfig
    au BufEnter ~/.files/git/commit_msg            se ft=gitcommit
  aug END
en

" }}}
" ==============================================================================
" PLUGINS {{{
" ==============================================================================

" ----------------------------------------------------------------------------
" NERDTree
" ----------------------------------------------------------------------------
" au VimEnter * NERDTree     " Enable NERDTree on Vim start-up

" Autoclose NERDTree if it's the only open window left
au BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") &&
\ b:NERDTree.isTabTree()) | q | endif

" Open NERDTree at the current file or close NERDTree if pressed again
nn <silent> <expr> <Leader>n g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"

" Have NERDtree show hidden files, but ignore certain files and directories
let NERDTreeShowHidden=1
let NERDTreeIgnore=['__pycache__','\.git$', '\.jpg$', '\.mp4$', '\.ogg$', '\.iso$', '\.pyc$', '\.odt$', '\.png$', '\.gif$', '\~$', 'pip-log\.txt$', 'whoosh_index', 'xapian_index', '.*.pid', 'monitor.py', '.*-fixtures-.*.json', '.*\.o$', 'db.db']

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
hi Floaterm guibg=black
" Set floating window border line colour to cyan, and background to orange
hi FloatermBorder guibg=orange guifg=cyan

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
" Rainbow parentheses
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

au VimEnter * RainbowParenthesesToggle
au Syntax   * RainbowParenthesesLoadRound
au Syntax   * RainbowParenthesesLoadSquare
au Syntax   * RainbowParenthesesLoadBraces


" ----------------------------------------------------------------------------
" Spelunker
" ----------------------------------------------------------------------------
" Disable URI checking
let g:spelunker_disable_uri_checking                          = 1

" Disable email-like words checking
let g:spelunker_disable_email_checking                        = 1

" Disable account name checking, e.g. @foobar, foobar@
let g:spelunker_disable_account_name_checking                 = 1

" Disable acronym checking
let g:spelunker_disable_acronym_checking                      = 1

" Disable checking words in backtick/backquote
let g:spelunker_disable_backquoted_checking                   = 1

" Disable default autogroup
let g:spelunker_disable_auto_group                            = 1

" Override highlight setting
hi SpelunkerSpellBad cterm=underline ctermfg=247 gui=underline guifg=#9e9e9e
hi SpelunkerComplexOrCompoundWord cterm=underline ctermfg=NONE gui=underline guifg=NONE


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

com! -bang VimDir call fzf#vim#files('~/.files/', <bang>0)


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
" Fake
" ----------------------------------------------------------------------------
"" Choose a random element from a list
call fake#define('sex', 'fake#choice(["male", "female"])')

"" Get a name of male or female
"" fake#int(1) returns 0 or 1
call fake#define('name', 'fake#int(1) ? fake#gen("male_name")'
      \ . ' : fake#gen("female_name")')

"" Get a full name
call fake#define('fullname', 'fake#gen("name") . " " . fake#gen("surname")')

"" Get a nonsense text like Lorem ipsum
call fake#define('sentense', 'fake#capitalize('
      \ . 'join(map(range(fake#int(3,15)),"fake#gen(\"nonsense\")"))'
      \ . ' . fake#chars(1,"..............!?"))')

call fake#define('paragraph', 'join(map(range(fake#int(3,10)),"fake#gen(\"sentense\")"))')

"" Alias
call fake#define('lipsum', 'fake#gen("paragraph")')

"" Get an age weighted by generation distribution
call fake#define('age', 'float2nr(floor(110 * fake#betapdf(1.0, 1.45)))')

"" Get a domain (ordered by number of websites)
call fake#define('gtld', 'fake#get(fake#load("gtld"),'
      \ . 'fake#betapdf(0.2, 3.0))')

call fake#define('email', 'tolower(substitute(printf("%s@%s.%s",'
      \ . 'fake#gen("name"),'
      \ . 'fake#gen("surname"),'
      \ . 'fake#gen("gtld")), "\\s", "-", "g"))')

" }}}
" ============================================================================
" MAPPINGS {{{
" ============================================================================

" ----------------------------------------------------------------------------
" Quit Vim
" ----------------------------------------------------------------------------
nn <Leader>q :q<CR>


" ----------------------------------------------------------------------------
" Line operations
" ----------------------------------------------------------------------------
" Add a blank space before the cursor
nn <Space><Space>   a<Space><Left><Esc>
" Add a blank space after the cursor
nn <Bslash><Space>  i<Space><Left><Esc>


" ----------------------------------------------------------------------------
" Press double ,, to escape from Insert mode
" ----------------------------------------------------------------------------
ino ;; <Esc>
vn ;; <Esc>


" ----------------------------------------------------------------------------
" Fix 'Y' and 'vv' behaviours
" ----------------------------------------------------------------------------
nn Y y$
nn vv <C-V>$


" ----------------------------------------------------------------------------
" Keep cursor at the bottom of the visual selection after you yank it
" ----------------------------------------------------------------------------
vm y ygv<Esc>


" ----------------------------------------------------------------------------
" Undo break points
" ----------------------------------------------------------------------------
ino , ,<C-G>u
ino . .<C-G>u
ino [ [<C-G>u
ino ( (<C-G>u
ino { {<C-G>u
ino < <<C-G>u
ino ' '<C-G>u
ino ! !<C-G>u
ino ? ?<C-G>u


" ----------------------------------------------------------------------------
" Move text
" ----------------------------------------------------------------------------
vn J :m '>+1<CR>gv=gv
vn K :m '<-2<CR>gv=gv


" ----------------------------------------------------------------------------
" Visual Shifting (does not exit Visual mode)
" ----------------------------------------------------------------------------
vn < <gv
vn > >gv


" ----------------------------------------------------------------------------
" Record into register 'q' (use 'qq'), playback with 'Q'
" ----------------------------------------------------------------------------
nn Q @q


" ----------------------------------------------------------------------------
" Folding shortcuts
" ----------------------------------------------------------------------------
" Press {za} to open/close all folding levels.
nn za zA
vn za zA

" Press {zo} to open every fold.
nn zo zR
vn zo zR

" Press {zc} to close every fold.
nn zc zM
vn zc zM

" Start editing with all folds closed
set foldlevelstart=0


" ----------------------------------------------------------------------------
" Colon shortcuts to access command line mode.
" ----------------------------------------------------------------------------
nn ; :
vn ; :


" ----------------------------------------------------------------------------
" Fast split navigation with <Ctrl> + hjkl
" ----------------------------------------------------------------------------
" 1. Normal mode
nn <C-H> <C-W><C-H>
nn <C-J> <C-W><C-J>
nn <C-K> <C-W><C-K>
nn <C-L> <C-W><C-L>
" 2. Terminal mode
tno <C-H> <C-W><C-H>
tno <C-J> <C-W><C-J>
tno <C-K> <C-W><C-K>
tno <C-L> <C-W><C-L>


" ----------------------------------------------------------------------------
" Resize split windows using arrow keys by pressing:
" CTRL+UP, CTRL+DOWN, CTRL+LEFT, or CTRL+RIGHT.
" ----------------------------------------------------------------------------
" 1. Normal mode
nn <C-up> <C-w>+
nn <C-down> <C-w>-
nn <C-left> <C-w>>
nn <C-right> <C-w><
" 2. Terminal mode
tno <C-up> <C-w>+
tno <C-down> <C-w>-
tno <C-left> <C-w>>
tno <C-right> <C-w><


" ----------------------------------------------------------------------------
" Move the current window to the corresponding position.
" ----------------------------------------------------------------------------
nn <C-W>h <C-W>H
nn <C-W>j <C-W>J
nn <C-W>k <C-W>K
nn <C-W>l <C-W>L


" ----------------------------------------------------------------------------
" Map arrow keys nothing so I can get used to hjkl-style movement.
" ----------------------------------------------------------------------------
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>


" ----------------------------------------------------------------------------
"  Change Working Directory to that of the current file.
" ----------------------------------------------------------------------------
cno cwd lcd %:p:h
cno cd. lcd %:p:h


" ----------------------------------------------------------------------------
" Allow using the repeat operator with a visual selection (!)
" ----------------------------------------------------------------------------
vn . :normal .<CR>


" ----------------------------------------------------------------------------
" Display a list of current buffers and prompting for which buffer to access.
" ----------------------------------------------------------------------------
nn <Leader>b :ls<CR>:b<Leader>


" ----------------------------------------------------------------------------
" Indent | Dedent in with a visual selection.
" ----------------------------------------------------------------------------
vn <Tab> >gv
vn <S-Tab> <gv


" ----------------------------------------------------------------------------
" Open a bash terminal vertically
" ----------------------------------------------------------------------------
nn <Leader>t :vert term bash<CR><C-\><C-N>:vert resize -20<CR>a

" }}}
" ============================================================================
" HOTKEYS {{{
" ============================================================================

let g:HelpMeItems = [
    \ "Shortcuts:",
    \ "<BS>g                toggle Goyo",
    \ "<BS>m                toggle Maximizer for the current window",
    \ "<BS>t                toggle Floaterm",
    \ "<Space>F             open FZF for files under home directory",
    \ "<Space>f             open FZF for files under working directory",
    \ "<Space>m             toggle Tabman",
    \ "<Space>n             toggle NERDTree",
    \ "<Space>u             toggle Undotree",
    \ "<Space>b             list current buffers",
    \ "<F2>                 fold all unchanged lines",
    \ "<F3>                 show changed lines with differences",
    \ "<F4>                 toggle parentheses highlighting",
    \ "<F5>                 (1) Execute script; (2) Generate ToC/Align tables",
    \ "",
    \ "Commands:",
    \ ":AddLineNumber       add line numbers to each line",
    \ ":CapitaliseEachWord  capitalise every word in the current line",
    \ ":ClearRegisters      clear all Vim's registers",
    \ ":GB                  super cheap Git blame",
    \ ":Root                change directory to the Git repository's root",
    \ "",
    \ "Press 'q' to close",
    \ ]

nn  <silent> <Bslash>es  : sp ~/.files/dictionary/en.utf-8.add <CR>
nn  <silent> <Bslash>eg  : tabe ~/.files/git/gitconfig         <CR>
nn  <silent> <Bslash>ev  : tabe $MYVIMRC                     <CR>
nn  <silent> <Bslash>sv  : so $MYVIMRC                       <CR>
nn  <silent> <Bslash>k   : HelpMe                            <CR>
nn  <silent> <Bslash>t   : FloatermToggle                    <CR>
tno <silent> <Bslash>t   <C-\><C-n>:FloatermToggle           <CR>
nn  <silent> <Bslash>g   : Goyo                              <CR>
nn  <silent> <Bslash>m   : MaximizerToggle                   <CR>
vn  <silent> <Bslash>m   : MaximizerToggle                   <CR> gv
nn  <silent> <Leader>F   : FZF -m ~                          <CR>
nn  <silent> <Leader>f   : FZF -m                            <CR>
nn  <silent> <Leader>u   : UndotreeToggle                    <CR>
nn  <silent> <F2>        : SignifyFold                       <CR>
nn  <silent> <F3>        : SignifyDiff                       <CR>
nn  <silent> <F4>        : RainbowParenthesesOn              <CR>

" }}}
" ============================================================================
" FUNCTIONS & COMMANDS {{{
" ============================================================================

" ----------------------------------------------------------------------------
" :AddLineNumber | Add line numbers to each line
" ----------------------------------------------------------------------------
fu! AddLineNumber()
  %s/^/\=printf('%-3d',line('.'))
  %s/\s\+$//e
  ec 'Every Line Has Been Numbered!'
endf
com! AddLineNumber call AddLineNumber()

" ----------------------------------------------------------------------------
" :CapitaliseEachWord
" ----------------------------------------------------------------------------
fu! CapitaliseEachWord()
  s/\v<(.)(\w*)/\u\1\L\2/g
  ec 'Every Word Has Been Capitalised!'
endf
com! CapitaliseEachWord call CapitaliseEachWord()


" ----------------------------------------------------------------------------
" :ClearRegisters
" ----------------------------------------------------------------------------
com! ClearRegisters for i in range(34,122) | silent! call setreg(nr2char(i), [])
      \| endfor | ec 'All Registers Has Been Cleared!'


" ----------------------------------------------------------------------------
" :GB | Annotate each highlighted line with information from the revision
"       which last modified the line.
" ----------------------------------------------------------------------------
" Source: https://gist.github.com/romainl/5b827f4aafa7ee29bdc70282ecc31640
com! -range GB echo join(systemlist("git -C " . shellescape(expand('%:p:h')) . " blame -L <line1>,<line2> " . expand('%:t')), "\n")


" ----------------------------------------------------------------------------
" :FixQuotes | Look through the whole file and change the “ and ” to "
" ----------------------------------------------------------------------------
fu! FixQuotes()
  :silent! %s/“/"/g
  :silent! %s/”/"/g
  :silent! %s/‘/'/g
  :silent! %s/’/'/g
  ec "‘ and ’ have been substituted with '!"
  ec '“ and ” have been substituted with "!'
endf
com! FixQuotes call FixQuotes()


" ----------------------------------------------------------------------------
" RainbowParentheses
" ----------------------------------------------------------------------------
fu! RainbowParenthesesOn()
  :RainbowParenthesesToggle       " Toggle it on/off
  :RainbowParenthesesLoadRound    " (), the default when toggling
  :RainbowParenthesesLoadSquare   " []
  :RainbowParenthesesLoadBraces   " {}
  :RainbowParenthesesLoadChevrons " <>
  ec 'RainbowParentheses Has Been Toggled!'
endf
com! RainbowParenthesesOn call RainbowParenthesesOn()


" ----------------------------------------------------------------------------
" :Root | Change directory to the root of the Git repository
" ----------------------------------------------------------------------------
fu! s:root()
  let root = systemlist('git rev-parse --show-toplevel')[0]
  if v:shell_error
    ec 'Not in git repo'
  else
    exe 'lcd' root
    ec 'Changed directory to: '.root
  end
endf
com! Root call s:root()


" ----------------------------------------------------------------------------
" :StripTrailingWhitespace
" ----------------------------------------------------------------------------
fu! StripTrailingWhitespace()
  if !&binary && &filetype != 'diff'
    if &readonly==0 && filereadable(bufname('%'))
      let l:save = winsaveview()
      keepp %s/\s\+$//e
      call winrestview(l:save)
      ec 'Trailing Whitespace Has Been Stripped!'
    end
  end
endf
com! StripTrailingWhitespace call StripTrailingWhitespace()

" }}}
" ============================================================================
" VIM SCRIPTS {{{
" ============================================================================

" ----------------------------------------------------------------------------
" Highlights
" ----------------------------------------------------------------------------
fu! MyHighlights() abort
  " Badly spelled word
  hi SpellBad    cterm=NONE ctermbg=LightGrey  ctermfg=DarkRed gui=NONE guibg=#5fd700 guifg=#d70000
  " Word with wrong caps
  " hi SpellCap    cterm=NONE ctermbg=LightCyan  ctermfg=DarkRed gui=NONE guibg=#5fd700 guifg=#d70000
  " Rare word
  hi SpellRare   cterm=NONE ctermbg=LightCyan  ctermfg=DarkRed gui=NONE guibg=#5fd700 guifg=#d70000
  " Word only exists in other region
  hi SpellLocal  cterm=NONE ctermbg=LightYellow ctermfg=DarkRed gui=NONE guibg=#5fd700 guifg=#d70000

  " Source: https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f
  hi Visual                 ctermbg=76         ctermfg=16      gui=NONE guibg=#5fd700 guifg=#000000
  " hi StatusLine cterm=NONE ctermbg=231 ctermfg=160 gui=NONE guibg=#ffffff guifg=#d70000
  " hi Normal     cterm=NONE ctermbg=17              gui=NONE guibg=#00005f
  " hi NonText    cterm=NONE ctermbg=17              gui=NONE guibg=#00005f

  hi clear CursorLine
  hi colorcolumn ctermbg=232
  hi Error ctermbg=red term=reverse
  hi LineNr ctermfg=darkgrey
  hi Search ctermbg=darkcyan ctermfg=white cterm=none
  hi Comment cterm=italic
  hi CursorLineNR cterm=none ctermfg=grey
  hi SignColumn ctermbg=none
  hi Folded guibg=Gray8 guifg=Gray ctermbg=235  ctermfg=0
endf

aug MyColors
    au!
    au ColorScheme * call MyHighlights()
    au ColorScheme * highlight SpecialKey ctermfg=238
aug END


" SignColumn should match background
hi clear SignColumn

" Remove highlight colour from current line number
hi clear CursorLineNr

" Current line number row will have same background colour in relative mode
" hi clear LineNr

" Highlight conflicts
mat ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'


" ----------------------------------------------------------------------------
" Ignore URLs and file paths when spellchecking
"  ----------------------------------------------------------------------------
fun! SpellCheckIgnoreRules()
  if (&filetype=='markdown')
    syn case match
    syn match spellcheckURL /\<http[^ ]\+/
    syn match spellcheckFilepath / \/.*\>/
    syn match spellcheckCamelCase /\<[A-Z][a-z]\+[A-Z].\{-}\>/
    syn case ignore
  else
    syn match spellcheckURL /\<http[^ ]\+/ contains=@NoSpell transparent
    syn match spellcheckFilepath / \/.*\>/ contains=@NoSpell transparent
    syn match spellcheckCamelCase /\<[A-Z][a-z]\+[A-Z].\{-}\>/ contains=@NoSpell transparent
    syn cluster Spell add=spellcheckURL
    syn cluster Spell add=spellcheckFilepath
    syn cluster Spell add=spellcheckCamelCase
  endif
endfunction

autocmd BufRead,BufNewFile * :call SpellCheckIgnoreRules()


" ----------------------------------------------------------------------------
" Open pdf files in the default pdf reader
" ----------------------------------------------------------------------------
au BufRead *.pdf sil exe "!xdg-open " . shellescape(expand("%:p")) | bd | let &ft=&ft | redraw!


" ----------------------------------------------------------------------------
" Disable making changes to file (plugins)
" ----------------------------------------------------------------------------
aug readonly
  au!
  au BufEnter ~/.files/pack/* setl nomodifiable
  au BufEnter ~/.files/pack/* setl nocursorline nocursorcolumn
aug END


" ----------------------------------------------------------------------------
" Show the cursor line in the active buffer.
" ----------------------------------------------------------------------------
augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END


" ----------------------------------------------------------------------------
" Enable relative numbers in Normal mode; absolute numbers in Insert mode.
" ----------------------------------------------------------------------------
aug toggle_relative_number
  au!
  au InsertEnter * setl nornu
  au InsertLeave * setl rnu
  au InsertLeave * redraw!
aug END


" ----------------------------------------------------------------------------
" Automatically centre the current line when I enter it in Insert mode.
" ----------------------------------------------------------------------------
au InsertEnter * norm zz


" ----------------------------------------------------------------------------
" Disable automatic commenting on the new line
" ----------------------------------------------------------------------------
au FileType * setl formatoptions-=c formatoptions-=r formatoptions-=o


" ----------------------------------------------------------------------------
" Automatically save the file when a change if made
" ----------------------------------------------------------------------------
au TextChanged,InsertLeave * if &readonly==0 && filereadable(bufname('%'))|silent up|end


" ----------------------------------------------------------------------------
" Configuration for colour scheme
" ----------------------------------------------------------------------------
syntax on

if has('termguicolours')
  se termguicolours
end

if &term =~ "xterm\\|rxvt"
  " use a light_cyan cursor in insert mode
  let &t_SI = "\<Esc>]12;LightCyan\x7"
  " use an orange cursor otherwise
  let &t_EI = "\<Esc>]12;LightGreen\x7"
  silent !ec -ne "\033]12;LightGreen\007"
end


" ----------------------------------------------------------------------------
" Configuration gruvbox-material
" ----------------------------------------------------------------------------
aug GruvboxMaterial

  packadd gruvbox-material
  let g:gruvbox_material_background = 'hard'
  " Enable italic, but disable for comment
  let g:gruvbox_material_enable_italic = 1
  let g:gruvbox_material_disable_italic_comment = 1
  " Enable bold in function name
  let g:gruvbox_material_enable_bold = 1
  " Control the |hl-Visual| and the |hl-VisualNOS| highlight group.
  let g:gruvbox_material_visual = 'reverse'
  " Customise the background colour of |hl-PmenuSel| and |hl-WildMenu|
  let g:gruvbox_material_menu_selection_background = 'red'
  " Make the background colour of sign column the same as normal text
  let g:gruvbox_material_sign_column_background = 'none'
  " The contrast of line numbers, indent lines, etc.
  let g:gruvbox_material_ui_contrast = 'high'
  " Some plugins support highlighting error/warning/info/hint texts, by default
  " these texts are only underlined, but you can use this option to also
  " highlight the background of them.
  let g:gruvbox_material_diagnostic_text_highlight = 1
  " Some plugins support highlighting error/warning/info/hint lines, but this
  " feature is disabled by default in this colour scheme.
  let g:gruvbox_material_diagnostic_line_highlight = 1
  " Some plugins can use virtual text feature of neovim to display
  " error/warning/info/hint information, you can use this option to adjust the
  " colours of it.
  let g:gruvbox_material_diagnostic_virtual_text = 'colored'
  " Some plugins can highlight the word under current cursor, you can use this
  " option to control their behaviour.
  let g:gruvbox_material_current_word = 'bold'
  " Determine the style of statusline
  let g:gruvbox_material_statusline_style = 'original'
  " Enable this option will reduce loading time by approximately 50%
  let g:gruvbox_material_better_performance = 1

aug END

colo gruvbox-material


" ----------------------------------------------------------------------------
" Change colour scheme depending on the time of day
" ----------------------------------------------------------------------------
let hr=(strftime('%H'))

if hr >= 18
  se background=dark
  hi ColorColumn guibg=DarkRed ctermbg=DarkRed
elsei hr >= 7
  se background=light
el
  se background=dark
  hi ColorColumn guibg=DarkRed ctermbg=DarkRed
end


" ------------------------------------------------------------------------------
" Detect trailing whitespace
" ----------------------------------------------------------------------------
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight trailing whitespace
se list


" ----------------------------------------------------------------------------
" Resize splits when the window is resized
" ----------------------------------------------------------------------------
au VimResized * exe "normal! \<c-w>="


" ----------------------------------------------------------------------------
" Line Return
" Make sure Vim returns to the same line when you reopen a file.
" ----------------------------------------------------------------------------
aug line_return
  au!
  au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ en
aug END

" }}}
" ============================================================================
" STATUS LINE {{{
" ============================================================================

let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
end
let g:airline_skip_empty_sections = 1
let g:airline_theme='gruvbox_material'

" Unicode Symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.maxlinenr = '☰'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'

" }}}
