" Author    : Henry Mai <henryfromvietnam@gmail.com>

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
" => Load plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" packloadall          " Load all plugins
silent! helptags ALL   " Load help for all plugins
source $DOTVIM/pack/plugins.vim
source $DOTVIM/pack/lf.vim


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Load word files
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
source $DOTVIM/wordlist/abbreviation/common.vim
source $DOTVIM/wordlist/abbreviation/custom.vim
set dictionary+=/usr/share/hunspell/en_AU.dic
set dictionary+=/usr/share/dict/english-words/words.txt
set spellfile+=$DOTVIM/wordlist/spellfile/en.utf-8.add
set spellfile+=/usr/share/dict/moby_words/acronyms.txt.utf-8.add
set spellfile+=/usr/share/dict/moby_words/common.txt.utf-8.add
set spellfile+=/usr/share/dict/moby_words/compound.txt.utf-8.add
set spellfile+=/usr/share/dict/moby_words/names-f.txt.utf-8.add
set spellfile+=/usr/share/dict/moby_words/names-m.txt.utf-8.add
set spellfile+=/usr/share/dict/moby_words/names.txt.utf-8.add
set spellfile+=/usr/share/dict/moby_words/places.txt.utf-8.add
set spellfile+=/usr/share/dict/moby_words/single.txt.utf-8.add
set thesaurus+=/usr/share/dict/moby_words/mthesaur.txt


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vietnamese wordlist
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set dictionary+=/usr/share/dict/vn_words/Viet74K.txt


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Reload files on exit
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au BufWinLeave $DOTFILES/doc/quotes/technology :!strfile technology
au BufWinLeave $DOTFILES/doc/quotes/inspiration :!strfile inspiration
au BufWinLeave $DOTFILES/bash/crontab :!sudo cp % /etc/crontab


" ============================================================================
" ENVIRONMENT {{{
" ============================================================================
" Identify platform {
silent fu! OSX()
  return has('macunix')
endf
silent fu! LINUX()
  return has('unix') && !has('macunix') && !has('win32unix')
endf
silent fu! WINDOWS()
  return (has('win32') || has('win64'))
endf
" }

" Basics {
se nocompatible        " Must be first line
if !WINDOWS()
  se shell=/bin/bash
en
" }

" Windows Compatible {
" On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
" across (heterogeneous) systems easier.
if WINDOWS()
  se runtimepath=$DOTVIM,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$DOTFILES/after
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
set wildmenu                              " Enable autocompletion after <TAB>
set wildmode=list:longest,list:full       " Use BASH style completion

set wig+=.hg,.git,.svn                    " Version control
set wig+=*.aux,*.out,*.toc,*.log,*.idx    " LaTeX intermediate files
set wig+=*_aux,*.glg,*.glo,*.gls,*.ist    " LaTeX intermediate files
set wig+=*.nlo,*.nls,*.pdf,*.bbl,*.dvi    " still LaTeX intermediate files
set wig+=*.ilg,*.fdb_latexmk,*.synctex.gz " $(B!D(B LaTeX intermediate files
set wig+=*.blg,*.ind                      " $(B!D!D!D(B LaTeX intermediate files
set wig+=*.hi                             " Haskell linker files
set wig+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wig+=*.mp4                            " binary videos
set wig+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wig+=*.spl                            " compiled spelling word lists
set wig+=*.sw?                            " Vim swap files
set wig+=*.DS_Store                       " OSX bullshit
set wig+=*.luac                           " Lua byte code
set wig+=migrations                       " Django migrations
set wig+=*.pyc                            " Python byte code
set wig+=*.orig                           " Merge resolution files
set wig+=classes
set wig+=lib
set wig+=*~,*/node_modules*,_site,*/__pycache__*,*/venv*,*/target*
set wig+=*/.vim$,\~$,*/.log,*/.aux,*/.cls,*/.aux,*/.bbl,*/.blg,*/.fls
set wig+=*/.fdb*,*/.toc,*/.out,*/.glo,*/.log,*/.ist,*/.fdb_latexmk,*.iso

" Better Completion
set completeopt=longest,menuone,preview,noinsert,noselect
set complete=.,w,b,u,k,t,],s{*.pm}

" Omni Completion
set omnifunc=syntaxcomplete#Complete
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete


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
  " Create undo directory if possible and does not exist yet
  let undodir = expand('$DOTVIM/.tmp/undodir/')
  if !isdirectory(undodir) && getftype(undodir) == "" && exists("*mkdir")
    call mkdir(undodir, "p", 0o700)
  endif
  let &undodir = undodir
  set undofile
  " Maximum number of changes that can be undone
  set undolevels=1000
  " Maximum number lines to save for undo on a buffer reload
  set undoreload=10000
endif


" ----------------------------------------------------------------------------
" Create backup directory in case of crashes
" ----------------------------------------------------------------------------
if has("writebackup")
  let backupdir = expand('$DOTVIM/.tmp/backupdir/')
  " Create backup directory if possible and does not exist yet
  if !isdirectory(backupdir) && getftype(backupdir) == "" && exists("*mkdir")
    call mkdir(backupdir, "p", 0o700)
  endif
  let &backupdir = backupdir
  let &backupext = '-' .. strftime("%Y%b%d-%H:%M") .. '.bak'
  " let &backupskip = '.git/*, /tmp/*'
  set backup
endif


" ----------------------------------------------------------------------------
" Do not create swapfiles
" ----------------------------------------------------------------------------
set noswapfile


" }}}
" ==============================================================================
" TEMPLATES & CUSTOM VIM FILETYPE SETTINGS {{{
" ==============================================================================

aug templates
  au BufNewFile *.sh   0r $DOTVIM/template/sh.template
  au BufNewFile *.html 0r $DOTVIM/template/html.template
  au BufNewFile *.py   0r $DOTVIM/template/python.template
aug END

aug filetypes
  au BufEnter *.template,*.txt                   setf text
  au BufEnter *.md                               setf markdown
  au BufEnter *.jade                             setf pug
  au BufEnter *.pug                              setf pug
  au BufEnter *.coffee                           setf coffee
  au BufEnter $DOTFILES/git/*                    setf gitconfig
  au BufEnter *.sh,$DOTFILES/bash/*              setf bash
  au BufEnter $DOTFILES/sh/*,$DOTFILES/install/* setf bash
aug END

" }}}
" ==============================================================================
" COLOUR SCHEMES {{{
" ==============================================================================

syntax on

if has('termguicolors')
  set termguicolors
end

if &term =~ "xterm\\|rxvt"
  " use a light_cyan cursor in insert mode
  let &t_SI = "\<Esc>]12;LightCyan\x7"
  " use an orange cursor otherwise
  let &t_EI = "\<Esc>]12;LightGreen\x7"
  silent !echo -ne "\033]12;LightGreen\007"
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

colo gruvbox

" ----------------------------------------------------------------------------
" Change background colour depending on the time of day
" ----------------------------------------------------------------------------
if exists("*strftime")
  let hr=(strftime('%H'))
  if hr >= 18
    set background=dark
  elseif hr >= 8
    set background=light
  else
    set background=dark
  endif
endif


" ----------------------------------------------------------------------------
" Highlights
" ----------------------------------------------------------------------------
fu! MyHighlights() abort
  " Badly spelled word
  hi SpellBad cterm=NONE ctermfg=009 ctermbg=011
  " Word with wrong caps
  " hi SpellCap cterm=NONE ctermbg=LightCyan ctermfg=DarkRed
  " Rare word
  hi SpellRare cterm=NONE ctermbg=LightCyan ctermfg=DarkRed
  " Word only exists in other region
  hi SpellLocal cterm=italic ctermbg=White ctermfg=DarkRed

  " Source: https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f
  hi Visual ctermbg=76 ctermfg=16
  " hi StatusLine cterm=NONE ctermbg=231 ctermfg=160
  " hi Normal     cterm=NONE ctermbg=17
  " hi NonText    cterm=NONE ctermbg=17

  " hi clear CursorLine
  hi ColorColumn ctermbg=LightRed ctermfg=Black
  hi ErrorMsg ctermbg=Red ctermfg=Yellow
  hi LineNr ctermfg=Darkgrey
  hi Search ctermbg=Darkcyan ctermfg=White cterm=none
  hi Comment cterm=italic
  " hi SignColumn ctermbg=DarkGrey
  " hi Folded ctermbg=235  ctermfg=0
endf

aug MyColors
    au!
    au ColorScheme * call MyHighlights() | highlight SpecialKey ctermfg=238
    au BufRead * colo gruvbox-material | call MyHighlights() | highlight SpecialKey ctermfg=238
    au SourcePost vimrc colo gruvbox-material | call MyHighlights() | highlight SpecialKey ctermfg=238
aug END

" Remove highlight colour from current line number
" hi clear CursorLineNr

" Current line number row will have same background colour in relative mode
" hi clear LineNr

" Highlight conflicts
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'


" ------------------------------------------------------------------------------
" Detect trailing whitespace
" ------------------------------------------------------------------------------
" Show tabs as ▷⋅ and trailing spaces as⋅
" http://got-ravings.blogspot.com/2008/10/vim-pr0n-statusline-whitespace-flags.html
set list
set listchars=tab:▷⋅,trail:⋅,nbsp:⋅,extends:#
function ToggleListchars()
    if &listchars =~ "eol"
        set listchars=tab:▷⋅,trail:⋅,nbsp:⋅
    else
        set listchars=tab:▷⋅,trail:⋅,nbsp:⋅,eol:$
    endif
endfunction

com! ToggleListchars call ToggleListchars()
highlight ExtraWhitespace ctermbg=DarkRed ctermfg=Black
match ExtraWhitespace /\s\+$/


" ------------------------------------------------------------------------------
" Do not highlight all-cap words
" ------------------------------------------------------------------------------
syntax match None "\v<[A-Z]+>"
syntax match None "\v<[A-Z]+s>"
syntax match None "\v<[A-Z]+[0-9]>"

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
" Switch tabs easily
" ----------------------------------------------------------------------------
nn <Tab> gt
nn <S-Tab> gT


" ----------------------------------------------------------------------------
" Use lf to select and open file(s)
" ----------------------------------------------------------------------------
nn <Leader>l :LF<CR>


" ----------------------------------------------------------------------------
" Open NERDTree at the current file or close NERDTree if pressed again
" ----------------------------------------------------------------------------
nn <silent> <expr> <Leader>n g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"

" }}}
" ============================================================================
" HOTKEYS {{{
" ============================================================================

let g:HelpMeItems = [
    \ "Shortcuts:",
    \ "<BS>g                toggle Goyo",
    \ "<BS>k                open HelpMe",
    \ "<BS>m                toggle Maximizer for the current window",
    \ "<BS>t                toggle Floaterm",
    \ "<Space>G             google the word under cursor",
    \ "<Space>GG            google the Word/URL under cursor",
    \ "<Space>D             define the word under cursor",
    \ "<Space>b             quickly explore active buffers",
    \ "<Space>bt            toggle bufexplorer",
    \ "<Space>t             access the thesaurus for the word under cursor",
    \ "<F2>                 fold all unchanged lines",
    \ "<F3>                 show changed lines with differences",
    \ "<F4>                 toggle git changes highlighting",
    \ "<F5>                 (1) Execute script; (2) Generate ToC/Align tables",
    \ "<F6>                 Change DOS-style line endings to Unix-style",
    \ "",
    \ "Commands:",
    \ ":AddLineNumber       add line numbers to each line",
    \ ":ClearRegisters      clear all Vim's registers",
    \ ":GB                  super cheap Git blame",
    \ ":Root                change directory to the Git repository's root",
    \ ]

nn  <silent> <Bslash>eb  : tabe $DOTFILES/bash/bashrc                  <CR>
nn  <silent> <Bslash>eg  : tabe $DOTFILES/git/gitconfig                <CR>
nn  <silent> <Bslash>es  : sp $DOTVIM/wordlist/abbreviation/common.vim <CR>
nn  <silent> <Bslash>ev  : tabe $MYVIMRC                               <CR>
nn  <silent> <Bslash>sv  : so $MYVIMRC                                 <CR>
nn  <silent> <Bslash>k   : HelpMe                                      <CR>
nn  <silent> <Bslash>t   : FloatermToggle                              <CR>
tno <silent> <Bslash>t   <C-\><C-n>:FloatermToggle                     <CR>
nn  <silent> <Bslash>g   : Goyo                                        <CR>
nn  <silent> <Bslash>m   : MaximizerToggle                             <CR>
vn  <silent> <Bslash>m   : MaximizerToggle                             <CR> gv
nn  <silent> <Leader>f   : FZF -m                                      <CR>
nn  <silent> <Leader>u   : MundoToggle                                 <CR>
nn  <silent> <F2>        : SignifyFold                                 <CR>
nn  <silent> <F3>        : SignifyDiff                                 <CR>
nn  <silent> <F4>        : GitGutterLineHighlightsToggle               <CR>
nn  <silent> <F6>        : !dos2unix %                             <CR><CR>

" }}}
" ============================================================================
" FUNCTIONS {{{
" ============================================================================

" ----------------------------------------------------------------------------
" :AddLineNumber | Add line numbers to each line
" ----------------------------------------------------------------------------
fu! AddLineNumber()
  %s/^/\=printf('%-3d',line('.'))
  %s/\s\+$//e
  echo 'Every Line Has Been Numbered!'
endf
com! AddLineNumber call AddLineNumber()


" ----------------------------------------------------------------------------
" :CapitaliseEachWord
" ----------------------------------------------------------------------------
fu! CapitaliseEachWord()
  silent '<,'>s/\v<(.)(\w*)/\u\1\L\2/g | redraw
  echo 'Every Word Has Been Capitalised!'
endf
vn \c :call CapitaliseEachWord()<CR>


" ----------------------------------------------------------------------------
" :ClearRegisters
" ----------------------------------------------------------------------------
com! ClearRegisters for i in range(34,122) | silent! call setreg(nr2char(i), [])
      \| endfor | echo 'All Registers Has Been Cleared!'


" ----------------------------------------------------------------------------
" :GB | Annotate each highlighted line with information from the revision
"       which last modified the line.
" ----------------------------------------------------------------------------
" Source: https://gist.github.com/romainl/5b827f4aafa7ee29bdc70282ecc31640
com! -range GB echo join(systemlist("git -C " . shellescape(expand('%:p:h'))
      \ . " blame -L <line1>,<line2> " . expand('%:t')), "\n")


" ----------------------------------------------------------------------------
" :FixQuotes | Change Unicode (“ and ”) to ASCII code (")
" ----------------------------------------------------------------------------
fu! FixQuotes()
  :silent! %s/“/"/g
  :silent! %s/”/"/g
  :silent! %s/‘/'/g
  :silent! %s/’/'/g
  echo "‘ and ’ have been substituted with '!"
  echo '“ and ” have been substituted with "!'
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
  echo 'RainbowParentheses Has Been Toggled!'
endf
com! RainbowParenthesesOn call RainbowParenthesesOn()


" ----------------------------------------------------------------------------
" :Root | Change directory to the root of the Git repository
" ----------------------------------------------------------------------------
fu! s:root()
  let root = systemlist('git rev-parse --show-toplevel')[0]
  if v:shell_error
    echo 'Not in git repo'
  else
    exe 'lcd' root
    echo 'Changed directory to: '.root
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
      echo 'Trailing Whitespace Has Been Stripped!'
    end
  end
endf
com! StripTrailingWhitespace call StripTrailingWhitespace()


" ----------------------------------------------------------------------------
" Allow spaces in thesaurus entries
" Source: https://www.reddit.com/r/vim/comments/55y53e/allow_spaces_in_thesaurus_entries/
" ----------------------------------------------------------------------------
function! s:thesaurus()
    let s:saved_ut = &ut
    if &ut > 200 | let &ut = 200 | endif
    augroup ThesaurusAuGroup
        autocmd CursorHold,CursorHoldI <buffer>
                    \ let &ut = s:saved_ut |
                    \ set iskeyword-=32 |
                    \ autocmd! ThesaurusAuGroup
    augroup END
    return ":set iskeyword+=32\<cr>vaWovea\<c-x>\<c-t>"
endfunction

nnoremap <expr> <leader>t <SID>thesaurus()


" ----------------------------------------------------------------------------
" Open URL under cursor in browser
" Source: https://github.com/jinzhu/configure/blob/master/.vimrc
" ----------------------------------------------------------------------------
function! OpenURL(url)
  let b:escape_url = escape(a:url, '"')
  if executable("firefox")
    execute "silent !firefox \"".b:escape_url."\""
  elseif executable("chromium")
    execute "silent !chromium \"".b:escape_url."\""
  elseif executable("gnome-open")
    execute "silent !gnome-open \"".b:escape_url."\""
  endif
  redraw!
endfunction
command! -nargs=1 OpenURL :call OpenURL(<q-args>)

nnoremap <Leader>G :OpenURL http://www.google.com/search?q=<cword><CR>
nnoremap <Leader>GG :OpenURL <cWORD><CR>
nnoremap <Leader>D :OpenURL https://www.oxfordlearnersdictionaries.com/definition/english/<cword><CR>
vnoremap <Leader>D "zy:OpenURL https://www.oxfordlearnersdictionaries.com/definition/english/<C-R>z<CR>


" ----------------------------------------------------------------------------
" e.g. inoremap <F5> <C-R>=ListMonths()<CR>
" ----------------------------------------------------------------------------
function! ListMonths()
  call complete(col('.'), ['January', 'February', 'March',
        \ 'April', 'May', 'June', 'July', 'August', 'September',
        \ 'October', 'November', 'December'])
  return ''
endfunction


" ----------------------------------------------------------------------------
" :Britishise
" ----------------------------------------------------------------------------
command! Britishise silent! runtime wordlist/plugins/britishise.vim
      \| echo 'Page Has Been Translated to British English'


" ----------------------------------------------------------------------------
" :Americanize
" ----------------------------------------------------------------------------
command! Americanize silent! runtime wordlist/plugins/americanize.vim
      \| echo 'Page Has Been Translated to American English'

" }}}
" ============================================================================
" VIM SCRIPTS {{{
" ============================================================================

" ----------------------------------------------------------------------------
" Ignore URLs and file paths when spellchecking
"  ----------------------------------------------------------------------------
fun! SpellCheckIgnoreRules()
  " if (&filetype=='markdown')
    syn case match
    syn match None /\<http[^ ]\+/
    syn match None / \/.*\>/
    syn match None /\<[A-Z][a-z]\+[A-Z].\{-}\>/
    syn case ignore
  " else
    " syn match spellcheckURL /\<http[^ ]\+/ contains=@NoSpell transparent
    " syn match spellcheckFilepath / \/.*\>/ contains=@NoSpell transparent
    " syn match spellcheckCamelCase /\<[A-Z][a-z]\+[A-Z].\{-}\>/ contains=@NoSpell transparent
    " syn cluster Spell add=spellcheckURL
    " syn cluster Spell add=spellcheckFilepath
    " syn cluster Spell add=spellcheckCamelCase
  " endif
endfunction

autocmd BufRead,BufNewFile * :call SpellCheckIgnoreRules()


" ----------------------------------------------------------------------------
" Open pdf files in the default pdf reader
" ----------------------------------------------------------------------------
au BufRead *.pdf sil exe "!xdg-open " . shellescape(expand("%:p")) | bd | let &ft=&ft | redraw!


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
