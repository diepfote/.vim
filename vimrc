"Vim needs a more POSIX compatible shell than fish for certain functionality to
"work, such as `:%!`, compressed help pages and many third-party addons.  If you
"use fish as your login shell or launch Vim from fish, you need to set `shell`
"to something else in your `~/.vimrc`, for example:
if &shell =~# 'fish$'
    set shell=bash
endif

" leave this at the top!!!
"
let mapleader = "\<space>"


set hidden  " do not require buffer writes before switching buffers


" do not write backup files
set nobackup
set nowritebackup

" disable swapfile
set noswapfile
" enable undofile -> undo edits even after closing a file
set undofile

set fsync  " flush file to disk



" resize windows with arrow keys
nnoremap <c-down>  :resize +2<cr>
nnoremap <c-up>  :resize -2<cr>
nnoremap <c-left>  :vertical resize -2<cr>
nnoremap <c-right>  :vertical resize +2<cr>


" swap movement commands
nnoremap (  :normal! {<cr>
nnoremap )  :normal! }<cr>
nnoremap {  :normal! (<cr>
nnoremap }  :normal! )<cr>


"disable compatibility
set nocompatible
" 'faster' backspace behavior I guess?
set backspace=indent,eol,start


" customize the wildmenu
set wildignore+=*.dll,*.o,*.pyc,*.bak,*.exe,*.jpg,*.jpeg,*.png,*.gif,*$py.class,*.class,*/*.dSYM/*,*.dylib,*.so,*.PNG,*.JPG
set wildmenu
set wildmode=longest:full,full

" for sidebars?
let g:netrw_list_hide='^\.\(pyc\|pyo\)$'



let os=substitute(system('uname'), '\n', '', '')
" to use :FZF
if os ==# 'Darwin' || os ==# 'Mac'
  " installed via Homebrew
  set rtp+=/usr/local/opt/fzf
elseif os ==# 'Linux'
  " installed via pacman
  set rtp+=/usr/bin/fzf
endif



if has('nvim')
  " Tell vim to remember certain things when we exit
  "  '10  :  marks will be remembered for up to 10 previously edited files
  "  "100 :  will save up to 100 lines for each register
  "  :20  :  up to 20 lines of command-line history will be remembered
  "  %    :  saves and restores the buffer list
  "  n... :  where to save the viminfo files
  set viminfo='10,\"100,:20,%,n~/.viminfo


  " ---------------------
  " jump to last location
  function! s:ResCur()
    if &ft =~? 'netrw'
      " do not run for netrw list
      return
    endif

    if line("'\"") <= line('$')
      normal! g`"
      return 1
    endif
  endfunction

  augroup resCur
    autocmd!
    autocmd BufWinEnter * call <SID>ResCur()
  augroup END
  " ---------------------


  set termguicolors
  " colorscheme lingodirector  "-> 'flazz/vim-colorschemes'
else
  set viminfo=
endif




" keep 5 lines at the top or bottom,
" depends on the scroll direction
set scrolloff=5

set cursorline

" do not show titles in bold print etc.
let html_no_rendering=1



" --------------------------------
set list  " always show some special chars -> listchars option

let g:listchars_for_space_enabled = 0
set listchars=tab:▴\ ,extends:#,nbsp:⍽
function! s:ToggleListCharsOptions()
  if ! g:listchars_for_space_enabled
    let g:listchars_for_space_enabled = 1
    set listchars=tab:▴\ ,extends:#,nbsp:⍽,space:·
  else
    let g:listchars_for_space_enabled = 0
    set listchars=tab:▴\ ,extends:#,nbsp:⍽
  endif
endfunction

command ToggleListCharsOptions :call <SID>ToggleListCharsOptions()
" --------------------------------


" wrap settings
set colorcolumn=72 " display vertical line to show character limit


" -----------
" statusline start

" %c -> column number
" %r -> readonly flag
set statusline =ft=%y
set statusline +=\ \ \ col:%-3c
set statusline +=%4r
set statusline +=\ %-3{ObsessionStatus()}

" display character value for the character the cursor is hovering over
set statusline +=%=cv:%3b,0x%2B

" git status info (branch name etc.)
set statusline +=%=\ %{fugitive#statusline()}

" current buffer name
set statusline +=\ \ %-10f

" statusline end
" -----------


" ---------
"  formatting start
set formatoptions=qrn1  " refer to https://neovim.io/doc/user/change.html#fo-table

" Commands not functions (no need for `:call <funcname>()` -> use plain `:<command>`
command! FormatXML :%!python3 -c "import xml.dom.minidom, sys;
                      \ print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"
command! FormatJSON :%!python3 -m json.tool

"  formatting start
" ---------



if exists('loaded_less')  " make vim behave like less
  set nonumber
else
  " useful for motion commands
  set relativenumber
  set number
endif

syntax on
filetype plugin indent on

" --------------
" security fixes
"
set modelines=0
set nomodeline
" --------------

" enable mouse pointer clicks!
set mouse=a



" ------------------------
"  focus related

" change to directory of current file automatically
function! s:ChangeToDirOfFile()
  let l:absolute_dir_to_file = '%:p:h'
  if isdirectory(expand(l:absolute_dir_to_file))
    execute 'lcd' . l:absolute_dir_to_file
  endif
endfunction
augroup focusChanges
  " do not duplicate autocmds on reload
  autocmd!

  autocmd FocusGained,BufEnter * :silent! !  " trigger file reload when buffer gets focus
  "au FocusLost * :wa " save on focus loss


  autocmd FocusGained,BufEnter * :call <SID>ChangeToDirOfFile()
augroup END
" ------------------------


" ------------------------
" start custom tab settings

" default
function! s:DefaultTabSettings()
    if &ft =~? 'python\|^c$\|haskell\|make\|^go$'
      " Do not set custom tab settings!
        set tabstop=4 shiftwidth=4
    elseif &ft =~? 'asm'
        set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
    elseif &ft =~? 'fstab'
        set tabstop=4 softtabstop=0 noexpandtab shiftwidth=4 nosmarttab
    else"
      set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
      endif
endfunction
augroup default_tab_settings
  " do not duplicate autocmds on reload
  autocmd!

  autocmd BufEnter,FocusGained * call <SID>DefaultTabSettings()
augroup END


" end custom tab settings
" ------------------------


" -----------------
" spell checking for latex files (de-AT)
"
augroup spell_lang
  " do not duplicate autocmds on reload
  autocmd!

  autocmd BufRead,BufNewFile *.tex setlocal spell spelllang=de_at
augroup END
" -----------------


" -----------------
" set custom ft
augroup set_custom_filetype_for_extensions
  " do not duplicate autocmds on reload
  autocmd!

  autocmd BufRead,BufNewFile config-* set ft=sshconfig
  autocmd BufRead,BufNewFile *.bib set ft=tex
  autocmd BufRead,BufNewFile *.rc set ft=sh
  autocmd BufRead,BufNewFile *.envrc set ft=sh
  autocmd BufRead,BufNewFile *.custom-envrc set ft=sh
  autocmd BufRead,BufNewFile *.service set ft=sh
  autocmd BufRead,BufNewFile *.conf set ft=sh
  autocmd BufRead,BufNewFile *.hook set ft=sh


  autocmd FocusGained,BufEnter ~/.mutt/*      set filetype=muttrc


  autocmd BufNewFile,BufRead /etc/firejail/*.profile      set filetype=firejail
  autocmd BufNewFile,BufRead /etc/firejail/*.local        set filetype=firejail
  autocmd BufNewFile,BufRead /etc/firejail/*.inc          set filetype=firejail
  autocmd BufNewFile,BufRead ~/.config/firejail/*.profile set filetype=firejail
  autocmd BufNewFile,BufRead ~/.config/firejail/*.local   set filetype=firejail
  autocmd BufNewFile,BufRead ~/.config/firejail/*.inc     set filetype=firejail
  autocmd BufNewFile,BufRead ~/Documents/firejail/etc/profile-*/*.profile set filetype=firejail
  autocmd BufNewFile,BufRead ~/Documents/firejail/etc/profile-*/*.local   set filetype=firejail
  autocmd BufNewFile,BufRead ~/Documents/firejail/etc/profile-*/*.inc     set filetype=firejail
augroup END

" -----------------


" -----------------
" remove trailing whitespace

function! s:StripTrailingWhitespace()
    " Don't strip on these filetypes
    " pattern to use:
    "
    "if &ft =~ 'markdown\|somethingelse'

    if &ft =~? 'markdown\|diff'
      return
    elseif &ft =~? 'yaml'
      " remove trailing new lines to pass zuul jobs
      %s/\($\n\s*\)\+\%$//e

      " no return --> fall through
    endif

    " default behavior, trim trailing whitespace in lines
    %s/\s\+$//e
endfunction

augroup trailing_whitespace
  " do not duplicate autocmds on reload
  autocmd!

  autocmd BufWritePre * call <SID>StripTrailingWhitespace()
augroup END
" -----------------


" -------------------------
" create directory if it does not exist
"
augroup Mkdir
  " do not duplicate autocmds on reload
  autocmd!

  autocmd BufWritePre * call mkdir(expand("<afile>:p:h"), "p")
augroup END
" -------------------------



" -----------------
" case insensitive search

set ignorecase   " change behavior with \C
" set smartcase    " but become case sensitive if you type uppercase characters

" -----------------



" -----------------
" vim-fish start
" Set up :make to use fish for syntax checking.

augroup fish_compiler
  " do not duplicate autocmds on reload
  autocmd!

  autocmd FileType fish compiler fish
augroup END
" vim-fish end
" -----------------



" -----------------------
" ncm2 tips

  " suppress the annoying 'match x of y',
  " 'The only match' and 'Pattern not found' messages
  set shortmess+=c

  " close pop-up on Escape key press
  inoremap <c-c> <ESC>
  " close pop-up on Escape key press
  inoremap jj <ESC>


  if has('nvim')
    " Use <TAB> to select the popup menu:
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  endif

" -----------------------


" remap PageUp to C-a
"nnoremap <C-a>  <C-b>

" do not jump to next line when lines are wrapped
nnoremap j gj
nnoremap k gk
nnoremap <down> gj
nnoremap <up> gk

" disable help
inoremap <F1> <NOP>
vnoremap <F1> <NOP>



" -------------------------------
" disable arrow keys in all modes

nnoremap <up> <NOP>
nnoremap <down> <NOP>
nnoremap <left> <NOP>
nnoremap <right> <NOP>

inoremap <up> <NOP>
inoremap <down> <NOP>
inoremap <left> <NOP>
inoremap <right> <NOP>

vnoremap <up> <NOP>
vnoremap <down> <NOP>
vnoremap <left> <NOP>
vnoremap <right> <NOP>
" -------------------------------


" -----------------
" window management
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

inoremap <C-h> <esc><C-w>ha
inoremap <C-j> <esc><C-w>ja
inoremap <C-k> <esc><C-w>ka
inoremap <C-l> <esc><C-w>la
" -----------------



" ----------------------------
" base64 encoding and decoding

function! s:CommonOperator(type)
  " echom a:type

  if a:type ==? 'v'
    " case insensitive -> linewise and charwise visual select

    " yank visually selected text
    execute 'normal! `<v`>y'
    return 1
  elseif a:type ==# '^V'
    " blockwise visual select

    " unsupported!
    return
  elseif a:type ==# 'char'
    " visually select range selected via character-
    " wise motion; then yank
    execute 'normal! `[v`]y'
    return 1
  else
    " TODO custom operator functionality
    " blockwise visual mode & linewise motions

    " return false  = 0 -> not supported
    return
  endif

endfunction

function! s:Base64DecodeOperator(type)
  let saved_unnamed_register = @"

  if <SID>CommonOperator(a:type)  " selects and copies motion
    let @"=system('base64 -d', @")
    normal! gvP
  endif

  let @" = saved_unnamed_register
endfunction

function! s:Base64EncodeOperator(type)
  let saved_unnamed_register = @"

  if <SID>CommonOperator(a:type)  " selects and copies motion
    let @"=system('base64 -w0', @")
    normal! gvP
  endif

  let @" = saved_unnamed_register
endfunction


" custom operator mappings
" TODO custom op mappings for blockwise visual mode & linewise motions
nnoremap <silent><leader>d64 :set operatorfunc=<SID>Base64DecodeOperator<cr>g@
vnoremap <silent><leader>d64 :<c-u>call <SID>Base64DecodeOperator(visualmode())<cr>
nnoremap <silent><leader>e64 :set operatorfunc=<SID>Base64EncodeOperator<cr>g@
vnoremap <silent><leader>e64 :<c-u>call <SID>Base64EncodeOperator(visualmode())<cr>

" ----------------------------

" --------------------------------------------------------------------
" json to yaml or back
"
function! s:ToJsonOperator(type)
  let saved_unnamed_register = @"

  if <SID>CommonOperator(a:type)  " selects and copies motion
    let @"=system('yq read - --prettyPrint --tojson', @")
    normal! gvP
  endif

  let @" = saved_unnamed_register
endfunction

function! s:ToYamlOperator(type)
  let saved_unnamed_register = @"

  if <SID>CommonOperator(a:type)  " selects and copies motion
    let @"=system('yq read - --prettyPrint', @")
    normal! gvP
  endif

  let @" = saved_unnamed_register
endfunction


" custom operator mappings
" TODO custom op mappings for blockwise visual mode & linewise motions
nnoremap <silent><leader>toj :set operatorfunc=<SID>ToJsonOperator<cr>g@
vnoremap <silent><leader>toj :<c-u>call <SID>ToJsonOperator(visualmode())<cr>
nnoremap <silent><leader>toy :set operatorfunc=<SID>ToYamlOperator<cr>g@
vnoremap <silent><leader>toy :<c-u>call <SID>ToYamlOperator(visualmode())<cr>

" --------------------------------------------------------------------


" ------------------
" vimrc helpers
" nicked from https://learnvimscriptthehardway.stevelosh.com/

function! s:VimrcSplit()
  :call <SID>VerticalSplitAndSwitch()
  :e ~/.vim/vimrc
endfunction

" open vimrc for editing
nnoremap <leader>ev :call <SID>VimrcSplit()<cr>

" source vimrc
nnoremap <leader>sc :source ~/.vim/vimrc<cr>

" ------------------


" ---------------------------
" split helpers

function! s:SplitAndSwitch()
  :split
  execute "normal! \<c-w>j"
endfunction

nnoremap <leader>sh :call <SID>SplitAndSwitch()<cr>

function! s:VerticalSplitAndSwitch()
  :vsplit
  execute "normal! \<c-w>l"
endfunction

nnoremap <leader>sv :call <SID>VerticalSplitAndSwitch()<cr>
" ---------------------------



" page up
nnoremap H <c-b>
vnoremap H <c-b>
" page down
nnoremap L <c-f>
vnoremap L <c-f>


" clear line
nnoremap <leader>c ddO<esc>



" -------------------
" textobj indentation
onoremap <silent>ai :<C-U>call <SID>IndTxtObj(0)<CR>
onoremap <silent>ii :<C-U>call <SID>IndTxtObj(1)<CR>
vnoremap <silent>ai :<C-U>call <SID>IndTxtObj(0)<CR><Esc>gv
vnoremap <silent>ii :<C-U>call <SID>IndTxtObj(1)<CR><Esc>gv

function! s:IndTxtObj(inner)
  let curline = line('.')
  let lastline = line('$')
  let i = indent(line('.')) - &shiftwidth * (v:count1 - 1)
  let i = i < 0 ? 0 : i
  if getline('.') !~? '^\\s*$'
    let p = line('.') - 1
    let nextblank = getline(p) =~? '^\\s*$'
    while p > 0 && ((i == 0 && !nextblank) || (i > 0 && ((indent(p) >= i && !(nextblank && a:inner)) || (nextblank && !a:inner))))
      -
      let p = line('.') - 1
      let nextblank = getline(p) =~? "^\\s*$"
    endwhile
    normal! 0V
    call cursor(curline, 0)
    let p = line('.') + 1
    let nextblank = getline(p) =~? '^\\s*$'
    while p <= lastline && ((i == 0 && !nextblank)
          \ || (i > 0 && ((indent(p) >= i && !(nextblank && a:inner))
          \ || (nextblank && !a:inner))))
      +
      let p = line('.') + 1
      let nextblank = getline(p) =~? '^\\s*$'
    endwhile
    normal! $
  endif
endfunction
" -------------------


" run sphinx via tox, after pandoc has turned the file in the current
" buffer (markdown) into an rst|restructured text file for sphinx
cnoremap p! ! name="$(echo % \| sed -r 's/\..*//' \| head -n1)";
                      \ pandoc "$name".md -o "$name".rst;
                      \ (cd "$(git rev-parse --show-toplevel)" && tox)

" sudo write this, no use with firejail obviously
cnoremap W! w !sudo tee % >/dev/null


" ----------------------------------------------
" Small helper that inserts a random uuid4
function! s:InsertUUID4()
python3 << endpython
import uuid, vim
vim.command('return "%s"' % str(uuid.uuid4()))
endpython
endfunction

" insert UUID in line below current line
command InsertUUID4  :call append(line('.'), <SID>InsertUUID4())

" ----------------------------------------------

" -----------------------------------
" prepend and append separating lines

function! s:AppendSeparator()
  normal mlyy}kp^v$r-xxgclk'l
endfunction
function! s:PrependSeparator()
  normal yyP^v$r-xxgclj
endfunction

command AppendSeparator  :call <SID>AppendSeparator()
command PrependSeparator  :call <SID>PrependSeparator()
" -----------------------------------


" -------------------------------
function! s:DeleteCharAtEndOfLine()
  normal! mz$x`z
endfunction

nnoremap <leader>d  :call s:DeleteCharAtEndOfLine()<cr>
                  \ :silent! call repeat#set("\<leader>d", -1)<cr>
" -------------------------------


" copy clipboard to no-name register
nnoremap <leader>gr" :let @"=@+<cr>
" copy no-name register to clipboard
nnoremap <leader>gr+ :let @+=@"<cr>


" Delete to Black Hole Register | Delete to Blackhole Register | Delete into the Void
" normal mode; combine with any textobject
nnoremap _d "_d
nnoremap _x "_x
" visual mode
vnoremap _d "_d<cr>
vnoremap _x "_x<cr>


" remap jump to line of mark to jump to pos
function! s:JumpToPos()
  let s:mark = nr2char(getchar())
  execute 'normal! `' . s:mark
endfunction
nnoremap ' :call <SID>JumpToPos()<cr>


" ---------------------------------------------------------------------
let s:replacement = ''  " global so last replacement will be remembered
function! s:ReplaceCharAtEndOfLine(isRepeat)
  if ! a:isRepeat
    let s:replacement = nr2char(getchar())
  endif
  execute 'normal! mz$r' . s:replacement . '`z'
  silent! call repeat#set("\<plug>ReplaceCharAtEndOfLineRepeat")
endfunction

nnoremap <silent> <plug>ReplaceCharAtEndOfLineRepeat
                  \ :<c-u>call <sid>ReplaceCharAtEndOfLine(1)<cr>
nnoremap <silent> <plug>ReplaceCharAtEndOfLine
                  \ :<c-u>call <sid>ReplaceCharAtEndOfLine(0)<cr>
nnoremap <leader>R <plug>ReplaceCharAtEndOfLine
" ---------------------------------------------------------------------


" ---------------------------------------------------------------------
let s:append_val = ''  " global so last append_val will be remembered
function! s:AppendCharAtEndOfLine(isRepeat)
  if ! a:isRepeat
    let s:append_val = nr2char(getchar())
  endif
  execute 'normal! mz$a' . s:append_val . '`z'
  silent! call repeat#set("\<plug>AppendCharAtEndOfLineRepeat")
endfunction

nnoremap <silent> <plug>AppendCharAtEndOfLineRepeat
                  \ :<c-u>call <sid>AppendCharAtEndOfLine(1)<cr>
nnoremap <silent> <plug>AppendCharAtEndOfLine
                  \ :<c-u>call <sid>AppendCharAtEndOfLine(0)<cr>
nnoremap <leader>sA <plug>AppendCharAtEndOfLine
" ---------------------------------------------------------------------







filetype plugin on
call plug#begin('~/.vim/plugged')
"    'github_user/repo_name'


" -----------------------------------
" coc language server

if has('nvim')
  Plug 'neoclide/coc.nvim'

  if os ==# 'Darwin' || os ==# 'Mac'
    let g:coc_global_extensions = ['coc-json', 'coc-yaml', 'coc-jedi', 'coc-diagnostic', 'coc-groovy']
    let g:coc_buffers_to_apply_to = '*.py,*.groovy'
  elseif os ==# 'Linux'
    let g:coc_global_extensions = ['coc-json', 'coc-yaml', 'coc-jedi', 'coc-diagnostic']
    let g:coc_buffers_to_apply_to = '*.py'
  endif

  augroup coc_mappings
    " do not duplicate autocmds on reload
    autocmd!


    " Symbol renaming.
    execute 'autocmd BufEnter,FocusGained ' . g:coc_buffers_to_apply_to . ' nmap <leader>rn <Plug>(coc-rename)'

    " GoTo code navigation.
    execute 'autocmd BufEnter,FocusGained ' . g:coc_buffers_to_apply_to . ' nmap <silent> gd <Plug>(coc-definition)'
    " Show References
    execute 'autocmd BufEnter,FocusGained ' . g:coc_buffers_to_apply_to . ' nmap <silent> gR <Plug>(coc-references)'
    " Show function signature
    execute 'autocmd BufEnter,FocusGained ' . g:coc_buffers_to_apply_to . " nmap <silent> gs :call CocActionAsync('doHover')<cr>"




    " Mappings for CoCList
    " Show all diagnostics.
    autocmd BufEnter,FocusGained *.py,*.groovy nmap <silent><nowait> <space>a  :<C-u>CocDiagnostic<cr>
    " Show commands.
    autocmd BufEnter,FocusGained *.py,*.groovy nmap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
    " Find symbol of current document.
    autocmd BufEnter,FocusGained *.py,*.groovy nmap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
  augroup END

  " Trigger completion.
  inoremap <silent><expr> <c-space> coc#refresh()

else
  " Trigger completion.
  inoremap <silent><expr> <c-@> coc#refresh()
endif
" -----------------------------------


Plug 'tpope/vim-vinegar'  " improve vim's netrw

Plug 'tpope/vim-afterimage'  " edit ICO, PNG, and GIF, PDFs and macos plists

" -----------------
" vim-commentary
Plug 'tpope/vim-commentary'

" custom comment strings
augroup firejail_commentstring
  " do not duplicate autocmds on reload
  autocmd!

  autocmd FileType firejail setlocal commentstring=#\ %s
augroup END
" -----------------


" ----------------------
" tagbar
"

Plug 'majutsushi/tagbar'
let g:tagbar_left = 1

" set shorcut for tagbar plugin
nnoremap <f8> :TagbarToggle<cr>

" set path to tags file
set tags=.git/tags
" ----------------------


" tmux-resurrect dependency (do :mksession automatically...)
" :Obsession <path-to-store>
Plug 'tpope/vim-obsession'


" ----------------------------
" check with `set runtimepath?
" let &runtimepath = '<path-to-ack.vim>,' . &runtimepath
  " e.g.
  " let &runtimepath = '/root/.vim/plugged/ack.vim,' . &runtimepath

Plug 'mileszs/ack.vim'

" Page up/down bindings
let g:ack_mappings = {
      \ 'H': '<c-b>',
      \ 'L': '<c-f>' }

" replace ack by ag
" let g:ackprg = 'ag --vimgrep'
" if only grep available
let g:ackprg = 'grep -n --exclude-dir=.git
                      \ --exclude-dir=.helm
                      \ --exclude-dir=.tox
                      \ --exclude-dir=.mypy_cache
                      \ --exclude-dir=.eggs
                      \ --exclude-dir=*.egg-info
                      \ --exclude-dir=*venv*
                      \ --exclude-dir=*build*
                      \ --exclude-dir=__pycache__
                      \ --exclude-dir=.pytest_cache
                      \ --exclude-dir=htmlcov
                      \ --exclude=Session.vim'
" ----------------------------


Plug 'airblade/vim-gitgutter'



" ---------------------
"  fzf integration
"
Plug 'junegunn/fzf.vim'

nnoremap M :Files<space>
let g:fzf_preview_window = ['up:50%:hidden', 'ctrl-/']
" ---------------------



" --------------------------------
" rainbow plugin
"

Plug 'luochen1990/rainbow'
" highlight corresponding parentheses
" :RainbowToggle
let g:rainbow_active = 1  " enabled

let g:rainbow_conf = {
\ 'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
\ 'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
\ 'guis': [''],
\ 'cterms': [''],
\ 'operators': '_,_',
\ 'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\ 'separately': {
\   '*': {},
\   'vim': {
\     'parentheses_options': 'containedin=vimFuncBody'
\   },
\   'sh': {
  \     'parentheses_options': 'containedin=Function,shFunction,shFunctionOne,shTestDoubleQuote,shDoubleQuote,shSetList,shSingleQuote,shConditional,shRange,shIf,shSet,shDblBrace contained',
\   },
\   'yaml': {
  \     'parentheses_options': 'containedin=yamlFlowString,yamlPlainScalar contained',
\   },
\ }
\}


  " check the syntax name and definitions under the cursor
nnoremap <f1> :echo synIDattr(synID(line('.'), col('.'), 0), 'name')<cr>
nnoremap <f2> :echo ("hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">")<cr>
nnoremap <f3> :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')<cr>
nnoremap <f4> :exec 'syn list '.synIDattr(synID(line('.'), col('.'), 0), 'name')<cr>

" --------------------------------


" --------------------------------
" colorscheme almost without color
"
Plug 'pbrisbin/vim-colors-off'

" ! On mac we cannot call this in the plugin section
"   it won't find the colorscheme that way.

" --------------------------------


" TODO: vim-endwise or vim-fish causes end statements to outdent all the way
" if ft=fish
"
Plug 'dag/vim-fish'

Plug 'vim-syntastic/syntastic'
let g:syntastic_vim_checkers = ['vint']
let g:syntastic_python_checkers = ['']  " disable syntastic for python

Plug 'tpope/vim-endwise'

Plug 'tweekmonster/local-indent.vim'  " highlight indentation with vertical colored line
augroup highlight_indentation
  " do not duplicate autocmds on reload
  autocmd!

  autocmd FileType yaml,markdown LocalIndentGuide +hl -cc
augroup END


" ---------------------------------
Plug 'christoomey/vim-sort-motion'  " type gs then the rest of your text objects & motions



" --------------------------------
" vim tmux runner settings
Plug 'christoomey/vim-tmux-runner'

" for Python and other languages with syntactic whitespace
let g:VtrStripLeadingWhitespace = 0
let g:VtrClearEmptyLines = 0
let g:VtrAppendNewline = 0
" --------------------------------

Plug 'glts/vim-magnum'  " dependency for vim-radical
Plug 'glts/vim-radical'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'  " e.g. ds" to delete surrounding quotes ; ysTEXTOBJECT'  to surround TEXTOBJECT with ' ; cs"' to change " to '
Plug 'tpope/vim-repeat'  " support native repeat operation '.' for plugins that implement tpope/vim-repeat





Plug 'inkarkat/vim-ingo-library'  " dependency for vim-mark and vim-ReplaceWithRegister
Plug 'inkarkat/vim-visualrepeat'  " dependency for vim-ReplaceWithRegister


" -----------------
" vim-mark
"
" to highlight a word under your cursor do: <leader>m
" to remove all highlights do: :MarkClear
"
Plug 'inkarkat/vim-mark'
let g:mwDefaultHighlightingPalette = 'extended'
" -----------------

Plug 'inkarkat/vim-ReplaceWithRegister'

Plug 'itspriddle/vim-shellcheck'


Plug 'florianbegusch/vim-primitive-yamlsort'



" ------------------------
" clam
Plug 'sjl/clam.vim'

" open below current window (horizontally)
let g:clam_winpos = 'belowright'

" type ! in normal or visual mode to run Clam quickly
nnoremap ! :Clam<space>source<space>~/.vim/source-me;<space>
vnoremap ! :ClamVisual<space>source<space>~/.vim/source-me;<space>
" ------------------------

" ------------------------
"  tabline
"
" DISABLED
"

" Plug 'mkitt/tabline.vim'
" always display...
" set showtabline=2
" ------------------------


Plug 'tpope/vim-tbone'  " select text, then do :Twrite pane-id/alias


" ---------------------------------------
Plug 'tpope/vim-fugitive'  " git from vim

function! <sid>FugitiveAddGoToParentTreeMapping()
  if !exists('b:fugitive_type')
    return
  endif

  if b:fugitive_type =~# '^\%(tree\|blob\)$'
    nnoremap <buffer> .. :edit %:h<CR>
  endif

endfunction
augroup fugitiveVim
  autocmd!
  autocmd BufEnter * :call <sid>FugitiveAddGoToParentTreeMapping()
augroup end
" ---------------------------------------


if has('nvim')
  " --------------
  "  ncm2
  "
  Plug 'roxma/nvim-yarp', { 'do': ':UpdateRemotePlugins' } " dependency for ncm2
  Plug 'ncm2/ncm2', { 'do': ':UpdateRemotePlugins' }

  " NOTE: you need to install completion sources to get completions. Check
  " our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki
  Plug 'ncm2/ncm2-bufword'
  Plug 'ncm2/ncm2-path'
  Plug 'ncm2/ncm2-jedi' " python completions


  " common lisp
  "Plug 'HiPhish/ncm2-vlime'  "  completions taken from vlime (requires
    "connection to vlime server)
  "Plug 'l04m33/vlime'  "https://github.com/l04m33/vlime#quickstart
"
  if has('nvim')
    augroup ncm2_for_buffer
      " do not duplicate autocmds on reload
      autocmd!

      autocmd BufEnter * call ncm2#enable_for_buffer()
    augroup END


    " IMPORTANT: :help Ncm2PopupOpen for more information
    set completeopt=noinsert,menuone,noselect
  endif


  " -----------------------
  " tmux-complete settings
  "
  Plug 'wellle/tmux-complete.vim' " vim completions from other tmux panes (used by ncm2)
  " to enable fuzzy matching disable filter_prefix -> set to 0
  let g:tmuxcomplete#asyncomplete_source_options = {
              \ 'name':      'tmuxcomplete',
              \ 'whitelist': ['*'],
              \ 'config': {
              \     'splitmode':      'words',
              \     'filter_prefix':   0,
              \     'show_incomplete': 1,
              \     'sort_candidates': 0,
              \     'scrollback':      0,
              \     'truncate':        0
              \     }
              \ }

  " -----------------------

  " ncm2 end
  " --------------


  " -----------------------------------
  "  vim-go settings start

  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

  augroup vim-go-mappings
    " do not duplicate autocmds on reload
    autocmd!

      " Symbol renaming.
      au FileType go nnoremap <leader>rn :GoRename<cr>

      " GoTo code navigation.
      au FileType go nnoremap <silent>gd <Plug>(go-def)
      au FileType go nnoremap <silent>gR :GoReferrers<cr>
  augroup END

  "  vim-go settings end
  " -----------------------------------

endif

call plug#end()


" pbrisbin/vim-colors-off
set background=light
colorscheme off
" set statusline color
highlight StatusLine gui=bold,reverse cterm=bold,reverse
" do not highlight current line
highlight CursorLine guifg=NONE guibg=NONE cterm=NONE ctermbg=NONE ctermfg=NONE
" change color for vertical line indicating character limit
highlight ColorColumn guifg=NONE guibg=seashell2



" set search highlight color
" hi Search cterm=NONE ctermfg=black ctermbg=white
"
set hlsearch  "to highlight in cterm
set incsearch
"
highlight Search gui=bold guifg=black guibg=LightYellow cterm=bold term=NONE ctermfg=black ctermbg=LightYellow
highlight IncSearch gui=underline,bold guifg=white guibg=red cterm=underline,bold term=NONE ctermfg=white ctermbg=DarkRed


" Remove gray background which makes CoC hints etc. hard to read
highlight CocFloating ctermbg=white guibg=white
" Disable underlining for Coc warnings
highlight CocWarningHighlight ctermbg=white guibg=white


" -------------
" Abbreviations

cabbrev rclt cheatsheets_commit_and_push
cabbrev rclf cheatsheets_pull

" -------------

