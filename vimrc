"Vim needs a more POSIX compatible shell than fish for certain functionality to
"work, such as `:%!`, compressed help pages and many third-party addons.  If you
"use fish as your login shell or launch Vim from fish, you need to set `shell`
"to something else in your `~/.vimrc`, for example:
if &shell =~# 'fish$'
    set shell=bash
endif
let os=substitute(system('uname'), '\n', '', '')

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


" -----------------------
let g:toggle_window_zoom_enabled = 0
function! s:ToggleWindowZoom()
  if g:toggle_window_zoom_enabled
     let g:toggle_window_zoom_enabled = 0
     execute "normal! \<c-w>="
  else
    let g:toggle_window_zoom_enabled = 1
     execute "normal! \<c-w>_" | execute "normal! \<c-w>\|"
  endif

endfunction

nnoremap <silent><leader>z  :call <SID>ToggleWindowZoom()<cr>
" -----------------------


" -----------------------
" snatched from  https://github.com/jessfraz/.vim/blob/5f0c5536acde95b0022ffec66b594c630512ff5f/vimrc#L199-L217
function! s:DeleteInactiveBufs()
  "From tabpagebuflist() help, get a list of all buffers in all tabs
  let tablist = []
  for i in range(tabpagenr('$'))
    call extend(tablist, tabpagebuflist(i + 1))
  endfor

  "Below originally inspired by Hara Krishna Dara and Keith Roberts
  "http://tech.groups.yahoo.com/group/vim/message/56425
  let nWipeouts = 0
  for i in range(1, bufnr('$'))
    if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
      "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
      silent exec 'bwipeout' i
      let nWipeouts = nWipeouts + 1
    endif
  endfor
  echomsg nWipeouts . ' buffer(s) wiped out'
endfunction

command Bdeleteall :call <SID>DeleteInactiveBufs()
" -----------------------


" swap movement commands
nnoremap (  :normal! {<cr>
nnoremap )  :normal! }<cr>
nnoremap {  :normal! (<cr>
nnoremap }  :normal! )<cr>


"disable compatibility
set nocompatible
" 'faster' backspace behavior I guess?
set backspace=indent,eol,start


" snatched from https://github.com/jessfraz/.vim/blob/5f0c5536acde95b0022ffec66b594c630512ff5f/vimrc#L59-L61
" open help vertically
command! -nargs=* -complete=help Help vertical belowright help <args>
autocmd FileType help wincmd L


" ----------------
"  netrw START

" for netrw_list_hide used in tpope/vim-vinegar:
" - parent dir
" - current dir
" - python bytecode and object files
" customize the wildmenu
set wildignore+=*.dll,*.o,*.py[c,o],*.bak,*.exe,*.jpg,*.jpeg,*.png,*.gif,*$py.class,*.class,*/*.dSYM/*,*.dylib,*.so,*.PNG,*.JPG,\.,\.\.
set wildmenu
set wildmode=longest:full,full

" keep browsing directory and netrw directories synced
" snatched from https://vonheikemen.github.io/devlog/tools/using-netrw-vim-builtin-file-explorer/
let g:netrw_keepdir = 0


"  netrw END
" ----------------



if has('nvim')
  " Tell vim to remember certain things when we exit
  "  '10  :  marks will be remembered for up to 10 previously edited files
  "  "100 :  will save up to 100 lines for each register
  "  :20  :  up to 20 lines of command-line history will be remembered
  "  %    :  saves and restores the buffer list
  "  n... :  where to save the viminfo files
  set viminfo='10,\"100,:20,%,n~/.viminfo

  " set transparency for pop-up windows
  set pumblend=20

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




" keep 0 lines at the top or bottom,
" depends on the scroll direction
set scrolloff=0

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
" tabline start

" always show
set showtabline=2
" set tabline=%!GetCwdRelativeToHome()

set tabline=ft=%y

" %r -> readonly flag
set tabline+=%5r
" %c -> column number
set tabline+=\ \ col:[%3c]

" display whether this session is set to auto-save
set tabline+=\ %-4{ObsessionStatus()}

" display character value for the character the cursor is hovering over
" decimal first, then hex
set tabline+=\ cv:[%3b,0x%2B]

" git status info (branch name etc.)
set tabline+=%=\ %-40{fugitive#statusline()}


" redraw tabline on almost any action
" snatched from https://vi.stackexchange.com/a/28928
augroup redrawTabline
  au CursorMoved,CursorMovedI,TextChanged,TextChangedP,CmdlineEnter,CmdlineLeave,CmdlineChanged *  :redrawtabline
augroup END


" tabline end
" -----------

" -----------
" statusline start

" current buffer name
set statusline=%=%-10F

" statusline end
" -----------


" ---------
"  formatting start
set formatoptions=qrn1  " refer to https://neovim.io/doc/user/change.html#fo-table

function s:FormatXML()
  :%!python3 -c "import xml.dom.minidom, sys;
        \ print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"

  execute 'g/^\s*$/d'
endfunction

" Commands not functions (no need for `:call <funcname>()` -> use plain `:<command>`
command! FormatXML :call <SID>FormatXML()
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

" cd | change to directory of current file automatically
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
    " TODO use files in ~/.vim/ftplugin/. e.g. https://github.com/AndrewRadev/Vimfiles/tree/main/ftplugin
    if &ft =~? 'python\|^c$\|haskell\|make\|^go$'
      " Do not set custom tab settings!
        set tabstop=4 shiftwidth=4
    elseif &ft =~? '^gitconfig$'
        set tabstop=2 shiftwidth=2
    elseif &ft =~? 'asm\|markdown'
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
" set custom ft
" TODO use files in ~/.vim/ftdetect/. e.g. https://github.com/AndrewRadev/Vimfiles/tree/main/ftdetect
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
  autocmd BufRead,BufNewFile *.d set ft=d


  autocmd BufNewFile,BufRead ~/.mutt/*      set ft=muttrc

  autocmd BufNewFile,BufRead */playbooks/*.yaml      set ft=yaml.ansible
  autocmd BufNewFile,BufRead */tests/*.yaml      set ft=yaml.ansible
  autocmd BufNewFile,BufRead */roles/*/*.yaml      set ft=yaml.ansible

  " json in yaml -> too many errors
  autocmd BufNewFile,BufRead */queries/*.yaml      set ft=
  " prometheus rules
  " templating in yaml -> too many errors
  autocmd BufNewFile,BufRead */*prometheus*.yaml      set ft=

  autocmd BufNewFile,BufRead /etc/firejail/*.profile      set ft=firejail
  autocmd BufNewFile,BufRead /etc/firejail/*.local        set ft=firejail
  autocmd BufNewFile,BufRead /etc/firejail/*.inc          set ft=firejail
  autocmd BufNewFile,BufRead ~/.config/firejail/*.profile set ft=firejail
  autocmd BufNewFile,BufRead ~/.config/firejail/*.local   set ft=firejail
  autocmd BufNewFile,BufRead ~/.config/firejail/*.inc     set ft=firejail
  autocmd BufNewFile,BufRead ~/Documents/firejail/etc/profile-*/*.profile set ft=firejail
  autocmd BufNewFile,BufRead ~/Documents/firejail/etc/profile-*/*.local   set ft=firejail
  autocmd BufNewFile,BufRead ~/Documents/firejail/etc/profile-*/*.inc     set ft=firejail
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
      execute '%s/\($\n\s*\)\+\%$//e'


      " no return --> fall through
    endif


    " default behavior, trim trailing whitespace in lines
    execute '%s/\s\+$//e'
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


" -----------------
" spell checking
"

" map next/previous misspelled word
map <C-t> [s
map <C-z> ]s

function! s:SetSpell()
  " setlocal spell spelllang=en_us,en_uk,de_at,medical
  setlocal spell spelllang=en_us
endfunction

augroup spell_lang

  " do not duplicate autocmds on reload
  autocmd!

  autocmd Filetype markdown,tex,rst call s:SetSpell()
augroup END
" -----------------

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


" nicked from https://github.com/justinmk/config/blob/d4c0a1733206c3a973dce10ce122d64456fd7eb9/.config/nvim/init.vim#L738
" repeat last command for each line of a visual selection
xnoremap . :normal .<CR>


" -----------------
" window management
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
    let @"=system('yq .', @")
    normal! gvP
  endif

  let @" = saved_unnamed_register
endfunction

function! s:ToYamlOperator(type)
  let saved_unnamed_register = @"

  if <SID>CommonOperator(a:type)  " selects and copies motion
    let @"=system('yq --yaml-output .', @")
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

function! s:SplitAndOpen(filename)
  :call <SID>VerticalSplitAndSwitch()
  execute ':e ' . a:filename
endfunction


nnoremap <leader>ev :call <SID>SplitAndOpen('~/.vim/vimrc')<cr>
nnoremap <leader>ep :call <SID>SplitAndOpen('~/.vim/plugins.vim')<cr>

" source vimrc
nnoremap <leader>sc :source ~/.vim/vimrc<cr>
" source tempfile
nnoremap <leader>st :source %<cr>

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

" snatched from https://github.com/jessfraz/.vim/blob/5f0c5536acde95b0022ffec66b594c630512ff5f/vimrc#L225-L226
" remove search hightlight
nnoremap <leader><space> :nohlsearch<CR>


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

" snatched from https://vi.stackexchange.com/questions/12835/how-do-i-jump-to-the-next-line-with-the-same-indent-level
function! GoToNextIndent(inc)
    " Get the cursor current position
    let currentPos = getpos('.')
    let currentLine = currentPos[1]
    let matchIndent = 0

    " Look for a line with the same indent level whithout going out of the buffer
    while !matchIndent && currentLine != line('$') + 1 && currentLine != -1
        let currentLine += a:inc
        let matchIndent = indent(currentLine) == indent('.')
    endwhile

    " If a line is found go to this line
    if (matchIndent)
        let currentPos[1] = currentLine
        call setpos('.', currentPos)
    endif
endfunction

augroup indentation_jump_yaml
  autocmd!
  autocmd Filetype yaml nnoremap ]] :call GoToNextIndent(1)<CR>
  autocmd Filetype yaml nnoremap [[ :call GoToNextIndent(-1)<CR>
augroup END
" -------------------


" run sphinx via tox, after pandoc has turned the file in the current
" buffer (markdown) into an rst|restructured text file for sphinx
cnoremap p! ! name="$(echo % \| sed -r 's/\..*//' \| head -n1)";
                      \ pandoc "$name".md -o "$name".rst;
                      \ (cd "$(git rev-parse --show-toplevel)" && tox)



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
function! DeleteCharAtEndOfLine()
  normal! mz$x`z
endfunction

nnoremap <leader>d  :call DeleteCharAtEndOfLine()<cr>
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





" -----------------------
" justinmk shell bind START
"
" whole section nicked from https://github.com/justinmk/config/blob/master/.config/nvim/init.vim#L933-L1012

" :shell
" Creates a global default :shell with maximum 'scrollback'.
func! s:ctrl_s(cnt, new, here) abort
  let init = { 'prevwid': win_getid() }
  let g:term_shell = a:new ? init : get(g:, 'term_shell', init)
  let d = g:term_shell
  let b = bufnr(':shell')

  if bufexists(b) && a:here  " Edit the :shell buffer in this window.
    exe 'buffer' b
    let d.prevwid = win_getid()
    return
  endif

  " Return to previous window.
  if bufnr('%') == b
    let term_prevwid = win_getid()
    if !win_gotoid(d.prevwid)
      wincmd p
    endif
    if bufnr('%') == b
      " Edge-case: :shell buffer showing in multiple windows in curtab.
      " Find a non-:shell window in curtab.
      let bufs = filter(tabpagebuflist(), 'v:val != '.b)
      if len(bufs) > 0
        exe bufwinnr(bufs[0]).'wincmd w'
      else
        " Last resort: WTF, just go to previous tab?
        " tabprevious
        return
      endif
    endif
    let d.prevwid = term_prevwid
    return
  endif

  " Go to existing :shell or create new.
  let curwinid = win_getid()
  if a:cnt == 0 && bufexists(b) && winbufnr(d.prevwid) == b
    call win_gotoid(d.prevwid)
  elseif bufexists(b)
    let w = bufwinid(b)
    if a:cnt == 0 && w > 0  " buffer exists in current tabpage
      call win_gotoid(w)
    else  " not in current tabpage; go to first found
      let ws = win_findbuf(b)
      if a:cnt == 0 && !empty(ws)
        call win_gotoid(ws[0])
      else
        exe ((a:cnt == 0) ? 'tab split' : a:cnt.'split')
        exe 'buffer' b
        " augroup nvim_shell
        "   autocmd!
        "   autocmd TabLeave <buffer> if winnr('$') == 1 && bufnr('%') == g:term_shell.termbuf | tabclose | endif
        " augroup END
      endif
    endif
  else
    let origbuf = bufnr('%')
    exe ((a:cnt == 0) ? 'tab split' : a:cnt.'split')
    terminal
    setlocal scrollback=-1
    " augroup nvim_shell
    "   autocmd!
    "   autocmd TabLeave <buffer> if winnr('$') == 1 && bufnr('%') == g:term_shell.termbuf | tabclose | endif
    " augroup END
    file :shell
    " XXX: original term:// buffer hangs around after :file ...
    bwipeout! #
    " Set alternate buffer to something intuitive.
    let @# = origbuf
    tnoremap <buffer> <C-s> <C-\><C-n>:call <SID>ctrl_s(0, v:false, v:false)<CR>
  endif
  " if a:enter
  "   startinsert  " enter terminal-mode
  " endif
  let d.prevwid = curwinid
endfunc
nnoremap <C-s> :<C-u>call <SID>ctrl_s(v:count, v:false, v:false)<CR>
nnoremap '<C-s> :<C-u>call <SID>ctrl_s(v:count, v:false, v:true)<CR>

" justinmk shell bind END
" -----------------------



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


source ~/plugins.vim

