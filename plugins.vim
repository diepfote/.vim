filetype plugin on
call plug#begin('~/.vim/plugged')
"    'github_user/repo_name'


" -----------------------------------
" coc language server BEGIN

Plug 'neoclide/coc.nvim', {'branch': 'release'}

let g:coc_global_extensions = ['coc-json', 'coc-yaml', 'coc-jedi', 'coc-diagnostic', 'coc-clangd', 'coc-markdownlint']
let g:coc_buffers_to_apply_to = '*.c,*.py,*.json,*.yaml,*.rs'

if os ==# 'Darwin' || os ==# 'Mac'

  "
  call extend(g:coc_global_extensions, ['coc-groovy', '@yaegassy/coc-ansible'])

  "
  " custom for Coc Mappings below
  let g:coc_buffers_to_apply_to = '*.groovy,*.conf,*.md,' . g:coc_buffers_to_apply_to
  let g:coc_filetype_map = {
\ 'yaml.ansible': 'ansible',
\ }

  " DISABLED on purpose
  " augroup playbooks
  " autocmd BufNewFile,BufRead */playbooks/*.yaml  set ft=yaml.ansible
  " autocmd BufNewFile,BufRead */tests/*.yaml      set ft=yaml.ansible
  " autocmd BufNewFile,BufRead */roles/*/*.yaml    set ft=yaml.ansible
  " augroup END

elseif os ==# 'Linux'
  " custom for Coc Mappings below
  let g:coc_buffers_to_apply_to = '' . g:coc_buffers_to_apply_to
endif


function! CocDiagnosticsReopen()
    :lcl
    :CocDiagnostics
endfunction


augroup coc_mappings
  " do not duplicate autocmds on reload
  autocmd!

  " Symbol renaming.
  execute 'autocmd BufEnter,FocusGained ' . g:coc_buffers_to_apply_to . ' nnoremap <leader>rn <Plug>(coc-rename)'

  " GoTo code navigation.
  execute 'autocmd BufEnter,FocusGained ' . g:coc_buffers_to_apply_to . ' nnoremap <silent> gd <Plug>(coc-definition)'
  " Show References
  execute 'autocmd BufEnter,FocusGained ' . g:coc_buffers_to_apply_to . ' nnoremap <silent> gR <Plug>(coc-references)'
  " Show function signature
  execute 'autocmd BufEnter,FocusGained ' . g:coc_buffers_to_apply_to . " nnoremap <silent> gs :call CocActionAsync('doHover')<cr>"


  " Mappings for CoCList
  " Show all diagnostics.
  execute 'autocmd BufEnter,FocusGained ' . g:coc_buffers_to_apply_to . ' nnoremap <silent><nowait>  <BackSpace><BackSpace>  :call CocDiagnosticsReopen()<cr>'
  execute 'autocmd BufEnter,FocusGained ' . g:coc_buffers_to_apply_to . ' nnoremap <silent><nowait>  <BackSpace><Enter>  :lcl<cr>'
  " Show commands.
  " execute 'autocmd BufEnter,FocusGained ' . g:coc_buffers_to_apply_to . ' nnoremap <silent><nowait> <space>c  :CocList commands<cr>'
  " Find symbol of current document.
  execute 'autocmd BufEnter,FocusGained ' . g:coc_buffers_to_apply_to . ' nnoremap <silent><nowait> <space>o  :CocList outline<cr>'
augroup END


" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <silent><expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"


" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" coc language server END
" -----------------------------------


"
" :[range]Join[!] [separator] [count] [flags]
"
" flags :
"   r : (reverse) join lines in reverse
"   k : (keep) don't remove joined line after join
"
" e.g.
" replace new lines with literal '\n', use `!` to keep leading/trailing whitespace
" :'<,>'Join! '\n'
" :'<,>'Join '\n'
"
Plug 'sk1418/Join'


" re-evaluated on 2024-03-06. keeping this in case I ever want to
" convert a binary plist file
Plug 'tpope/vim-afterimage'  " edit ICO, PNG, and GIF, PDFs and macos plists

" -----------------
" vim-commentary
Plug 'tpope/vim-commentary'

" custom comment strings
augroup custom_comment_strings
  " do not duplicate autocmds on reload
  autocmd!

  autocmd FileType firejail setlocal commentstring=#\ %s
  autocmd FileType text     setlocal commentstring=#\ %s
  autocmd FileType json     setlocal commentstring=//\ %s
augroup END
" -----------------


" netrw replacement
Plug 'justinmk/vim-dirvish'
" improve vim's netrw
" Plug 'tpope/vim-vinegar'
"


" -----------------------
" justinmk/vim-sneak
" f / t command improved
Plug 'justinmk/vim-sneak'
noremap f <Plug>Sneak_f
noremap F <Plug>Sneak_F
noremap t <Plug>Sneak_t
noremap T <Plug>Sneak_T

" :help sneak
" forward jump in normal mode ... s<whattosearchfor>
" backward jump in normal mode S<whattosearchfor>
"
let g:sneak#label = 1

" TODO 2024-03-06 use label-mode -> minimalist alternative
" to https://github.com/easymotion/vim-easymotion
" -----------------------



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

" replace ack by the silverlight seacher
" let g:ackprg = 'ag --exclude -f -a --vimgrep'
let g:ackprg = 'ag -f --vimgrep
                  \ --ignore-dir .git
                  \ --ignore-dir .helm
                  \ --ignore-dir .tox
                  \ --ignore-dir .pulumi
                  \ --ignore-dir .cache
                  \ --ignore-dir .mypy_cache
                  \ --ignore-dir .eggs
                  \ --ignore-dir *.egg-info
                  \ --ignore-dir *venv*
                  \ --ignore-dir _build
                  \ --ignore-dir __pycache__
                  \ --ignore-dir .ruff_cache
                  \ --ignore "*.pyc"
                  \ --ignore-dir .pytest_cache
                  \ --ignore poetry.lock
                  \ --ignore-dir htmlcov
                  \ --ignore "*.html"
                  \ --ignore build.*trace
                  \ --ignore Session.vim'
" if only grep available
" let g:ackprg = 'grep -n
                  " \ --exclude-dir=.git
                  " \ --exclude-dir=.helm
                  " \ --exclude-dir=.tox
                  " \ --exclude-dir=.pulumi
                  " \ --exclude-dir=.cache
                  " \ --exclude-dir=.mypy_cache
                  " \ --exclude-dir=.eggs
                  " \ --exclude-dir=*.egg-info
                  " \ --exclude-dir=*venv*
                  " \ --exclude-dir=_build
                  " \ --exclude-dir=__pycache__
                  " \ --exclude-dir=.ruff_cache
                  " \ --exclude="*.pyc"
                  " \ --exclude-dir=.pytest_cache
                  " \ --exclude=poetry.lock
                  " \ --exclude-dir=htmlcov
                  " \ --exclude="*.html"
                  " \ --exclude=build.*trace
                  " \ --exclude=Session.vim
"

" close quickfix window mapping
execute 'autocmd BufEnter,FocusGained * nnoremap <silent><nowait>  <BackSpace><Space>  :ccl<cr>'
" ----------------------------


Plug 'airblade/vim-gitgutter'


" ---------------------
"  fzf integration
"

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
noremap <leader>B :Buffers<CR>
noremap <leader>E :Files<CR>
let g:fzf_preview_window = ['up:50%:hidden', 'ctrl-/']
" ---------------------


" how to use it? the easiest way
" vim -b <filename>
Plug 'rootkiter/vim-hexedit'

" --------------------------------
" rainbow plugin
"

Plug 'luochen1990/rainbow'
" highlight corresponding parentheses
" :RainbowToggle
let g:rainbow_active = 1  " enabled

"
" Check current text object by pressing <F4>
"
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
\   'rst': {
  \     'parentheses_options': 'containedin=rstExDirective',
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
" colorscheme onehalf

Plug 'sonph/onehalf', { 'rtp': 'vim' }

function! <sid>SetColorScheme()
    if &ft =~? '^rst$\|^markdown$'
      call ColorOneHalfLight()
    else
      call ColorOff()
    endif
endfunction

augroup set_colorscheme_for_yaml_files
  " do not duplicate autocmds on reload
  autocmd!

  autocmd FocusGained,BufEnter * :call <sid>SetColorScheme()
augroup END

" --------------------------------

" --------------------------------
" colorscheme almost without color
"
Plug 'pbrisbin/vim-colors-off'

" ! On mac we cannot call this in the plugin section
"   it won't find the colorscheme that way.

" --------------------------------



Plug 'vim-syntastic/syntastic'
let g:syntastic_vim_checkers = ['vint']
let g:syntastic_python_checkers = ['']  " disable syntastic for python

" helps to end certain structures automatically
" e.g. adds "endfunction" if you start a function in vimscript
Plug 'tpope/vim-endwise'

" increase and decrease numbers and dates ... <ctrl-a>/<ctrl-x>
Plug 'tpope/vim-speeddating'

 " e.g. ds" to delete surrounding quotes ; ysTEXTOBJECT'  to surround TEXTOBJECT with ' ; cs"' to change " to '
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'  " support native repeat operation '.' for plugins that implement tpope/vim-repeat


Plug 'inkarkat/vim-ingo-library'  " dependency for vim-mark and vim-ReplaceWithRegister
Plug 'inkarkat/vim-visualrepeat'  " dependency for vim-ReplaceWithRegister


Plug 'inkarkat/vim-ReplaceWithRegister'
" -----------------
" vim-mark
"
" highlight a word under your cursor ... <leader>m
" highlight based on a regex pattern ... <leader>r
" to remove all highlights do: :MarkClear
"
" jump to the next mark (any) ... <leader>/
" jump to the next mark (same pattern) ... <leader>*
"
" set the palette ... :MarkPalette extended
" note: MarkPalette supports autocompletion
"
Plug 'inkarkat/vim-mark'
let g:mwDefaultHighlightingPalette = 'extended'
" -----------------


" ---------
" ShellCheck config

Plug 'itspriddle/vim-shellcheck'

function! ShellCheckReopen()
    :ccl
    :ShellCheck!
endfunction

augroup ShellCheck
  " do not duplicate autocmds on reload
  autocmd!

  autocmd FileType sh  nnoremap <silent><nowait>  <BackSpace><BackSpace>  :call ShellCheckReopen()<cr>
  autocmd FileType sh  nnoremap <silent><nowait>  <BackSpace><Enter>  :ccl<cr>
augroup end

" ----------

Plug 'diepfote/vim-primitive-yamlsort'




" built-in yaml syntax highlighting breaks if
" you have a array bracket expression.
"
" e.g.
" "{{ sources[0]}}"
Plug 'stephpy/vim-yaml'

" ---
" improve yaml file movement
"
" shows current yaml item in statusline
" Plug 'Einenlum/yaml-revealer'

" jump based on indentation level
"
" [- : Move to previous line of lesser indent than the current line.
" [+ : Move to previous line of greater indent than the current line.
" [= : Move to previous line of same indent as the current line that is separated from the current line by lines of different indents.
" ]- : Move to next line of lesser indent than the current line.
" ]+ : Move to next line of greater indent than the current line.
" ]= : Move to next line of same indent as the current line that is separated from the current line by lines of different indents.
Plug 'jeetsukumaran/vim-indentwise'

map K <Plug>(IndentWisePreviousEqualIndent)
map J <Plug>(IndentWiseNextEqualIndent)

" ---


" narrow range plugin / NarrowRange plugin
Plug 'chrisbra/NrrwRgn'



" tmux integration
" re-evaluated on 2024-03-06
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
  " do not duplicate autocmds on reload
  autocmd!

  autocmd BufEnter * :call <sid>FugitiveAddGoToParentTreeMapping()
augroup end
" ---------------------------------------


" -----------------------------------
" zig-vim

Plug 'ziglang/zig.vim'

augroup zig-vim-autocommands
  " do not duplicate autocmds on reload
  autocmd!

  " Symbol renaming.
  au FileType zig :compiler zig_build_exe
augroup END

" -----------------------------------

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

" the following does not work in neovim:
" ```
" cnoremap W! w !sudo tee % >/dev/null
" ```
" thus:
Plug 'lambdalisue/suda.vim'


" When pasting, it compresses all blank
" lines that result from the paste to a
" single one
" (or none, at the top and bottom of the file).
Plug 'AndrewRadev/whitespaste.vim'

" check `vimrc` for `@Disabled 2024-02-15` and `lessspace`
" trim whitespace on modified lines
Plug 'thirtythreeforty/lessspace.vim'
let g:lessspace_blacklist = ['diff', 'markdown']


" The plugin is designed to automatically rename closing
" HTML/XML tags when editing opening ones (or the other way around)
Plug 'AndrewRadev/tagalong.vim'


" add filetype bpftrace
Plug 'mmarchini/bpftrace.vim'

" ------------------------------
"  bufferize BEGIN

" I previously used 'sjl/clam.vim' which only bufferizes shell commands.
"
Plug 'AndrewRadev/bufferize.vim'
nnoremap ! :Bufferize<space>!<space>source<space>~/.vim/source-me;<space>

"  bufferize END
" ------------------------------


" toggle markdown checkboxes
" <leader>tt will either insert `[ ]` or toggle it
Plug 'diepfote/vim-checkbox'


" ------------
" GH Copilot plugins

" tpope's official client
Plug 'github/copilot.vim'

" copilot chat
Plug 'danbradbury/copilot-chat.vim'
nnoremap <leader>cc :CopilotChatOpen<CR>
vmap <leader>a <Plug>CopilotChatAddSelection  " Add visual selection to copilot window

" ------------


" ----------------------------
" parrot

Plug 'frankroeder/parrot.nvim'

" dependencies
Plug 'nvim-lua/plenary.nvim'
Plug 'MunifTanjim/nui.nvim'


" ----------------------------



call plug#end()



" ------------------
" settings for parrot
lua << EOF
require('parrot').setup({
    providers = {
      perplexity = {
        name = "perplexity",
        api_key = os.getenv("PERPLEXITY_API_KEY"),
        endpoint = "https://api.perplexity.ai/chat/completions",
        topic = {
          model = "r1-1776",
          params = {
            max_tokens = 64,
          },
        },
        models = {
          "sonar",
          "sonar-pro",
          "sonar-deep-research",
          "sonar-reasoning",
          "sonar-reasoning-pro",
          "r1-1776",
        },
      },
    }
})
EOF

nnoremap <leader>cp :PrtChatNew<CR>
" @TODO replace with mapping to Enter in normal mode.
" This requires a custom filetype for any parrot.nvim window you open.
nnoremap <leader>cu :PrtChatResponde<CR>
" ------------------

" -----------------------------------
" settings for tpope's gh copilot plugin

function! ToggleGhCopilot()
  let l:current_dir = expand('%:p:h')
  if l:current_dir =~# '.*/deploy-*/*'
     :Copilot enable
     return
  endif
  :Copilot disable
endfunction

let g:copilot_enabled = v:false
augroup gh_copilot
    autocmd BufEnter,FocusGained *  :call ToggleGhCopilot()
augroup END
" -----------------------------------




" -------------------------------
function! DeleteCharAtEndOfLine()
  normal! mz$x`z
endfunction

nnoremap <leader>d  :call DeleteCharAtEndOfLine()<cr>
                  \ :silent! call repeat#set("\<leader>d", -1)<cr>
" -------------------------------

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


function ChangeHighlightSearch()
  " set search highlight color
  " hi Search cterm=NONE ctermfg=black ctermbg=white
  "
  set hlsearch  "to highlight in cterm
  set incsearch
  "
  highlight Search gui=bold guifg=black guibg=yellow cterm=bold term=NONE ctermfg=black ctermbg=yellow
  highlight IncSearch gui=underline,bold guifg=white guibg=red cterm=underline,bold term=NONE ctermfg=white ctermbg=DarkRed
endfunction

function ChangeHighlightSelection()
  highlight Visual ctermbg=lightmagenta guibg=lightmagenta
  " highlight Visual ctermbg=lightblue guibg=lightblue
  " highlight Visual ctermbg=lightgray guibg=lightgray
endfunction

function ChangeHighlightCurrentLine()
  highlight CursorLine guifg=NONE guibg=lightyellow cterm=NONE ctermfg=NONE ctermbg=lightyellow
endfunction

function ChangeHighlightStatusLine()
  highlight StatusLine guibg=lightred guifg=#444444 ctermfg=grey ctermbg=lightred
endfunction

function ChangeHighlightTabLine()
  highlight TabLineFill guibg=lightblue guifg=#444444 ctermfg=grey ctermbg=lightblue
endfunction

function ChangeHighlightVerticalLine()
  " indicates character limit
  highlight ColorColumn guifg=NONE guibg=lightyellow
endfunction

function ColorSharedSettings()
  :RainbowToggleOn
  :MarkPalette extended

  call ChangeHighlightCurrentLine()
  call ChangeHighlightStatusLine()
  call ChangeHighlightTabLine()
  call ChangeHighlightVerticalLine()
  call ChangeHighlightSearch()
  call ChangeHighlightSelection()
endfunction

function ColorOneHalfLight()
  let l:colorscheme_name = 'onehalflight'
  if exists('g:colors_name')
    if g:colors_name ==# l:colorscheme_name
      return
    endif
  endif

  execute 'colorscheme ' . l:colorscheme_name

  call ColorSharedSettings()
endfunction

function ColorOff()
  let l:colorscheme_name = 'off'
  if exists('g:colors_name')
    if g:colors_name ==# l:colorscheme_name
      return
    endif
  endif

  " pbrisbin/vim-colors-off
  set background=light
  execute 'colorscheme ' . l:colorscheme_name

  call ColorSharedSettings()
endfunction


" -------------
" Abbreviations

cabbrev __commit cheatsheets_commit_and_push
cabbrev __pull cheatsheets_pull


cabbrev __rezepte rezepte_commit_and_push

" -------------
