filetype plugin on
call plug#begin('~/.vim/plugged')
"    'github_user/repo_name'


" -----------------------------------
" coc language server BEGIN

Plug 'neoclide/coc.nvim', {'branch': 'release'}

let g:coc_global_extensions = ['coc-json', 'coc-yaml', 'coc-jedi', 'coc-diagnostic', 'coc-clangd']

if os ==# 'Darwin' || os ==# 'Mac'

  " TODO change ft to yaml.ansible -> coc-ansible
  call extend(g:coc_global_extensions, ['coc-groovy', '@yaegassy/coc-ansible'])

  " custom for Coc Mappings below
  let g:coc_buffers_to_apply_to = '*.c,*.py,*.groovy,*.json,*.yaml,*.conf'
  let g:coc_filetype_map = {
\ 'yaml.ansible': 'ansible',
\ }

elseif os ==# 'Linux'
  " custom for Coc Mappings below
  let g:coc_buffers_to_apply_to = '*.c,*.py,*.json,*.yaml'
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

" coc language server END
" -----------------------------------



" -----------------------
" tmux-complete settings

" !broken since coc.nvim switched to its own popup window!

" Plug 'prabirshrestha/async.vim'
" Plug 'prabirshrestha/asyncomplete.vim'
" Plug 'wellle/tmux-complete.vim'
"   " to enable fuzzy matching disable filter_prefix -> set to 0
" let g:tmuxcomplete#asyncomplete_source_options = {
"             \ 'name':      'tmuxcomplete',
"             \ 'whitelist': ['*'],
"             \ 'config': {
"             \     'splitmode':      'words',
"             \     'filter_prefix':   0,
"             \     'show_incomplete': 1,
"             \     'sort_candidates': 0,
"             \     'scrollback':      0,
"             \     'truncate':        0
"             \     }
"             \ }

" -----------------------


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
" -----------------------

" coc language server END
" -----------------------------------

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


" netrw replacement
Plug 'justinmk/vim-dirvish'
" improve vim's netrw
" Plug 'tpope/vim-vinegar'
"

" f / t command improved
Plug 'justinmk/vim-sneak'
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T


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
let g:ackprg = 'ag -f -a --vimgrep'
" if only grep available
" let g:ackprg = 'grep -n
"                   \ --exclude-dir=.git
"                   \ --exclude-dir=.helm
"                   \ --exclude-dir=.tox
"                   \ --exclude-dir=.pulumi
"                   \ --exclude-dir=.cache
"                   \ --exclude-dir=.mypy_cache
"                   \ --exclude-dir=.eggs
"                   \ --exclude-dir=*.egg-info
"                   \ --exclude-dir=*venv*
"                   \ --exclude-dir=_build
"                   \ --exclude-dir=__pycache__
"                   \ --exclude-dir=.pytest_cache
"                   \ --exclude-dir=htmlcov
"                   \  --exclude="*.html"
"                   \ --exclude=build.*trace
"                   \ --exclude=Session.vim'
" ----------------------------


Plug 'airblade/vim-gitgutter'


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


Plug 'tweekmonster/local-indent.vim'  " highlight indentation with vertical colored line

" --------------------------------
" colorscheme onehalf

Plug 'sonph/onehalf', { 'rtp': 'vim' }

function! <sid>SetColorScheme()
    if &ft =~? '^yaml$\|^rst$\|^markdown$'
      call ColorOneHalfLight()
    else
      call ColorOff()
    endif
endfunction

augroup set_colorscheme_for_yaml_files
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


" TODO: vim-endwise or vim-fish causes end statements to outdent all the way
" if ft=fish
"
Plug 'dag/vim-fish'

Plug 'vim-syntastic/syntastic'
let g:syntastic_vim_checkers = ['vint']
let g:syntastic_python_checkers = ['']  " disable syntastic for python

Plug 'tpope/vim-endwise'

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
Plug 'Einenlum/yaml-revealer'

" jump based on indentation level
"
" [- : Move to previous line of lesser indent than the current line.
" [+ : Move to previous line of greater indent than the current line.
" [= : Move to previous line of same indent as the current line that is separated from the current line by lines of different indents.
" ]- : Move to next line of lesser indent than the current line.
" ]+ : Move to next line of greater indent than the current line.
" ]= : Move to next line of same indent as the current line that is separated from the current line by lines of different indents.
Plug 'jeetsukumaran/vim-indentwise'
" ---

" Add jinja2 syntax highlighting
Plug 'Glench/Vim-Jinja2-Syntax'


Plug 'chrisbra/NrrwRgn'


" Change restructured text highlighting
Plug 'habamax/vim-rst'



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

" Usage e.g.:
" :CtrlP  -> files
" :CtrlPBuffer -> buffers
" :CtrlPMixed  -> both + most recently used files
Plug 'ctrlpvim/ctrlp.vim'

" When pasting, it compresses all blank
" lines that result from the paste to a
" single one
" (or none, at the top and bottom of the file).
Plug 'AndrewRadev/whitespaste.vim'

" delete wrapping if-clauses, try-catch blocks, and similar constructs
" mapping `dh`
" or run `:Deleft`
Plug 'AndrewRadev/deleft.vim'

" Placing the cursor on \"two\" and executing :SidewaysLeft, the \"one\" and \"two\" arguments will switch their places
" def function(one, two, three):
"    pass
" def function(two, one, three):
"     pass
Plug 'AndrewRadev/sideways.vim'

" The plugin is designed to automatically rename closing
" HTML/XML tags when editing opening ones (or the other way around)
Plug 'AndrewRadev/tagalong.vim'


" ------------------------------
"  bufferize BEGIN

" I previously used 'sjl/clam.vim' which only bufferizes shell commands.
"
Plug 'AndrewRadev/bufferize.vim'
nnoremap ! :Bufferize<space>!<space>source<space>~/.vim/source-me;<space>

"  bufferize END
" ------------------------------


call plug#end()


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
  highlight ColorColumn guifg=NONE guibg=seashell2
endfunction

function ColorOneHalfLight()
  let l:colorscheme_name = 'onehalflight'
  if exists('g:colors_name')
    if g:colors_name ==# l:colorscheme_name
      return
    endif
  endif

  execute 'colorscheme ' . l:colorscheme_name
  :RainbowToggleOn
  :LocalIndentGuide +hl +cc
  call ChangeHighlightCurrentLine()
  call ChangeHighlightStatusLine()
  call ChangeHighlightTabLine()
  call ChangeHighlightSearch()
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
  :LocalIndentGuide -hl -cc
  :RainbowToggleOn
  call ChangeHighlightCurrentLine()
  call ChangeHighlightStatusLine()
  call ChangeHighlightTabLine()
  call ChangeHighlightVerticalLine()
  call ChangeHighlightSearch()
endfunction


" -------------
" Abbreviations

cabbrev __commit cheatsheets_commit_and_push
cabbrev __pull cheatsheets_pull

" -------------
"
