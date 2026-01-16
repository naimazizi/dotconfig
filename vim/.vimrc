" vim-bootstrap 2025-07-11 01:04:16
"*****************************************************************************
"" Vim-Plug core
"*****************************************************************************
let vimplug_exists=expand('~/.vim/autoload/plug.vim')
if has('win32')&&!has('win64')
  let curl_exists=expand('C:\Windows\Sysnative\curl.exe')
else
  let curl_exists=expand('curl')
endif

let g:vim_bootstrap_theme = "kanagawa"

if !filereadable(vimplug_exists)
  if !executable(curl_exists)
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent exec "!"curl_exists" -fLo " . shellescape(vimplug_exists) . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

" Required:
call plug#begin(expand('~/.vim/plugged'))

"*****************************************************************************
"" Plug install packages
"*****************************************************************************
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'vim-scripts/CSApprox'
Plug 'Raimondi/delimitMate'
Plug 'majutsushi/tagbar'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-rhubarb' " required by fugitive to :GBrowse
Plug 'menisadi/kanagawa.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'justinmk/vim-sneak'
Plug 'terryma/vim-multiple-cursors'
Plug 'liuchengxu/vim-which-key'
Plug 'github/copilot.vim'
Plug 'Konfekt/FastFold'
Plug 'machakann/vim-sandwich'
Plug 'tommcdo/vim-exchange'
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }
Plug 'sheerun/vim-polyglot'
Plug 'yuttie/comfortable-motion.vim'
Plug 'brooth/far.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'inkarkat/vim-AdvancedSorters' " advanced sorting of text.
Plug 'inkarkat/vim-ingo-library' 
Plug 'jdhao/better-escape.vim'
Plug 'kshenoy/vim-signature'
Plug 'vim-test/vim-test' 
Plug 'puremourning/vimspector', {'do': './install_gadget.py --enable-c --enable-python'}

if isdirectory('/usr/local/opt/fzf')
  Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
else
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
endif
let g:make = 'gmake'
if exists('make')
        let g:make = 'make'
endif
Plug 'Shougo/vimproc.vim', {'do': g:make}

"" Vim-Session
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'


"*****************************************************************************
"" Custom bundles
"*****************************************************************************

"*****************************************************************************
"*****************************************************************************

"" Include user's extra bundle
if filereadable(expand("~/.vimrc.local.bundles"))
  source ~/.vimrc.local.bundles
endif

call plug#end()

" Required:
filetype plugin indent on


"*****************************************************************************
"" Basic Setup
"*****************************************************************************"
"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set ttyfast

"" Fix backspace indent
set backspace=indent,eol,start

"" Tabs. May be overridden by autocmd rules
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab

"" Map leader to ,
let g:mapleader = "\<Space>"
let g:maplocalleader = ','

"" Enable hidden buffers
set hidden

"" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

set fileformats=unix,dos,mac

if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/sh
endif

" session management
let g:session_directory = "~/.vim/session"
let g:session_autoload = "no"
let g:session_autosave = "yes"
let g:session_command_aliases = 1

"*****************************************************************************
"" Visual Settings
"*****************************************************************************
syntax on
set ruler
set number

let no_buffers_menu=1
colorscheme kanagawa

" Better command line completion
set wildmenu

" mouse support
set mouse=a

set mousemodel=popup
set t_Co=256
set guioptions=egmrti
set gfn=Monospace\ 10

if has("gui_running")
  if has("gui_mac") || has("gui_macvim")
    set guifont=Menlo:h12
    set transparency=7
  endif
else
  let g:CSApprox_loaded = 1

  " IndentLine
  let g:indentLine_enabled = 1
  let g:indentLine_concealcursor = ''
  let g:indentLine_char = '┆'
  let g:indentLine_faster = 1


  if $COLORTERM == 'gnome-terminal'
    set term=gnome-256color
  else
    if $TERM == 'xterm'
      set term=xterm-256color
    endif
  endif

endif


if &term =~ '256color'
  set t_ut=
endif


"" Disable the blinking cursor.
set gcr=a:blinkon0

set scrolloff=3


"" Status bar
set laststatus=2

"" Use modeline overrides
set modeline
set modelines=10

set title
set titleold="Terminal"
set titlestring=%F

set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

if exists("*fugitive#statusline")
  set statusline+=%{fugitive#statusline()}
endif

" vim-airline
let g:airline_theme = 'powerlineish'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline_skip_empty_sections = 1

"*****************************************************************************
"" Abbreviations
"*****************************************************************************
"" no one is really happy until you have this shortcuts
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

"" NERDTree configuration
let g:NERDTreeChDirMode=2
let g:NERDTreeIgnore=['node_modules','\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 50
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite,*node_modules/
nnoremap <silent> <leader>e :NERDTreeToggle<CR>


" terminal emulation
nnoremap <silent> <leader>ft :terminal<CR>

" vim-test (LazyVim-style)
" t: test
nnoremap <silent> <leader>tt :TestNearest<CR>
nnoremap <silent> <leader>tT :TestFile<CR>
nnoremap <silent> <leader>ta :TestSuite<CR>
nnoremap <silent> <leader>tl :TestLast<CR>
nnoremap <silent> <leader>tg :TestVisit<CR>

" vimspector (LazyVim-style)
" d: debug
nnoremap <silent> <leader>db :call vimspector#ToggleBreakpoint()<CR>
nnoremap <silent> <leader>dB :call vimspector#ClearBreakpoints()<CR>
nnoremap <silent> <leader>dc :call vimspector#Continue()<CR>
nnoremap <silent> <leader>di :call vimspector#StepInto()<CR>
nnoremap <silent> <leader>do :call vimspector#StepOver()<CR>
nnoremap <silent> <leader>dO :call vimspector#StepOut()<CR>
nnoremap <silent> <leader>dr :call vimspector#Restart()<CR>
nnoremap <silent> <leader>dq :call vimspector#Stop()<CR>


"*****************************************************************************
"" Commands
"*****************************************************************************
" remove trailing whitespaces
command! FixWhitespace :%s/\s\+$//e

" vim-test + python defaults
let g:test#strategy = 'vimterminal'
let g:test#python#runner = 'pytest'
let g:test#python#pytest#options = '-q'

" vimspector (python)
let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_install_gadgets = ['debugpy']

"*****************************************************************************
"" Functions
"*****************************************************************************
if !exists('*s:setupWrapping')
  function s:setupWrapping()
    set wrap
    set wm=2
    set textwidth=79
  endfunction
endif

"*****************************************************************************
"" Autocmd Rules
"*****************************************************************************
"" The PC is fast enough, do syntax highlight syncing from start unless 200 lines
augroup vimrc-sync-fromstart
  autocmd!
  autocmd BufEnter * :syntax sync maxlines=200
augroup END

"" Remember cursor position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

"" txt
augroup vimrc-wrapping
  autocmd!
  autocmd BufRead,BufNewFile *.txt call s:setupWrapping()
augroup END

"" make/cmake
augroup vimrc-make-cmake
  autocmd!
  autocmd FileType make setlocal noexpandtab
  autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
augroup END

set autoread

"*****************************************************************************
"" Mappings
"*****************************************************************************
noremap <Leader>f. :e <C-R>=expand("%:p:h") . "/" <CR>
noremap <Leader>cf :Format<CR>

"" Split
noremap <Leader>- :<C-u>split<CR>
noremap <Leader><Bar> :<C-u>vsplit<CR>

"" Git
noremap <Leader>ga :Gwrite<CR>
noremap <Leader>gc :Git commit --verbose<CR>
noremap <Leader>gsh :Git push<CR>
noremap <Leader>gll :Git pull<CR>
noremap <Leader>gg :Git<CR>
noremap <Leader>gb :Git blame<CR>
noremap <Leader>gd :Gvdiffsplit<CR>
noremap <Leader>gr :GRemove<CR>
noremap <Leader>gs :Clap bcommits<CR>
"" Open current line on GitHub
nnoremap <Leader>go :.GBrowse<CR>

"" Search
noremap <Leader>sm :Clap marks<CR>
noremap <leader>sc :Clap command_history<CR>
noremap <leader>sh :Clap history<CR>
noremap <leader>sk :Clap maps<CR>
noremap <leader>s" :Clap registers<CR>


" session management
nnoremap <leader>qs :OpenSession<Space>
nnoremap <leader>qS :SaveSession<Space>
nnoremap <leader>qd :DeleteSession<CR>
nnoremap <leader>qq :CloseSession<CR>

"" Tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <silent> <S-t> :tabnew<CR>
nnoremap <silent> <leader>bn :tabnew<CR>

"" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>


"" fzf.vim
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"

" The Silver Searcher
if executable('ag')
  let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
  set grepprg=ag\ --nogroup\ --nocolor
endif

" ripgrep
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  set grepprg=rg\ --vimgrep
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
endif

cnoremap <C-P> <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <silent> <leader>, :Clap buffers<CR>
nnoremap <silent> <leader>bb :Clap buffers<CR>
nnoremap <silent> <leader><leader> :Clap files<CR>
nnoremap <silent> <leader>/ :Clap live_grep<CR>


" Tagbar
nmap <silent> <F4> :TagbarToggle<CR>
let g:tagbar_autofocus = 1

" Disable visualbell
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

"" Copy/Paste/Cut
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif

noremap YY "+y<CR>
noremap <leader>p "+gP<CR>
noremap XX "+x<CR>

if has('macunix')
  " pbcopy for OSX copy/paste
  vmap <C-x> :!pbcopy<CR>
  vmap <C-c> :w !pbcopy<CR><CR>
endif

"" Buffer nav
noremap <S-h> :bp<CR>
noremap <S-l> :bn<CR>

"" Close buffer
noremap <leader>bd :bd<CR>

"" Clean search (highlight)
nnoremap <silent> <leader><esc> :noh<cr>

"" Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

"*****************************************************************************
"" WhichKey
"*****************************************************************************
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
let g:which_key_map = {}
let g:which_key_map['b'] = {
      \ 'name' : '+Buffers',
        \ 'd' : [':bd', 'Delete current buffer'],
        \ 'b' : [':Clap buffers', 'List Buffers'],
        \ 'n' : [":tabnew", 'New Buffer'],
    \ }
let g:which_key_map['c'] = {
      \ 'name' : '+Code',
        \ 'a' : ['<Plug>(coc-codeaction-selected)', 'Code Actions'],
        \ 'f' : [':Format', 'Format Code'],
        \ 'F' : ['<Plug>(coc-format-selected)', 'Format Selected Code'],
        \ 'r' : ['<Plug>(coc-rename)', 'Rename Symbol'],
    \ }
let g:which_key_map['f'] = {
      \ 'name' : '+Files',
    \ }
let g:which_key_map['g'] = {
      \ 'name' : '+Git',
        \ 'a' : [':Gwrite', 'Stage current file'],
        \ 'c' : [':Git commit --verbose', 'Commit changes'],
        \ 'd' : [':Gvdiffsplit', 'Diff current file'],
        \ 'll' : [':Git pull', 'Pull changes'],
        \ 's' : [':Clap bcommits', 'Show commits for current buffer'],
        \ 'r' : [':GRemove', 'Remove current file from git'],
        \ 'b' : [':Git blame', 'Blame current file'],
    \ }
let g:which_key_map['h'] = {
      \ 'name' : '+Hunk',
        \ 's' : ['<Plug>(GitGutterStageHunk)', 'Stage Hunk'],
        \ 'u' : ['<Plug>(GitGutterUndoHunk)', 'Undo Hunk'],
        \ 'p' : ['<Plug>(GitGutterPreviewHunk)', 'Preview Hunk'],
    \ }
let g:which_key_map['s'] = {
      \ 'name' : '+Search',
        \ 'm' : [':Clap marks', 'Marks'],
        \ 'c' : [':Clap command_history', 'Command History'],
        \ 'h' : [':Clap history', 'History'],
        \ 'k' : [':Clap maps', 'Maps'],
        \ '"': [':Clap registers', 'Registers'],
        \ "d": [':CoCList Diagnostics', 'Diagnostics'],
    \ }

let g:which_key_map['t'] = {
      \ 'name' : '+Test',
        \ 't' : [':TestNearest', 'Test Nearest'],
        \ 'T' : [':TestFile', 'Test File'],
        \ 'a' : [':TestSuite', 'Test Suite'],
        \ 'l' : [':TestLast', 'Test Last'],
        \ 'g' : [':TestVisit', 'Test Visit'],
    \ }

let g:which_key_map['d'] = {
      \ 'name' : '+Debug',
        \ 'b' : [':call vimspector#ToggleBreakpoint()', 'Breakpoint'],
        \ 'B' : [':call vimspector#ClearBreakpoints()', 'Clear Breakpoints'],
        \ 'c' : [':call vimspector#Continue()', 'Continue'],
        \ 'i' : [':call vimspector#StepInto()', 'Step Into'],
        \ 'o' : [':call vimspector#StepOver()', 'Step Over'],
        \ 'O' : [':call vimspector#StepOut()', 'Step Out'],
        \ 'r' : [':call vimspector#Restart()', 'Restart'],
        \ 'q' : [':call vimspector#Stop()', 'Stop'],
    \ }
let g:which_key_map['q'] = {
      \ 'name' : '+Session',
        \ 's' : [':OpenSession ', 'Open Session'],
        \ 'S' : [':SaveSession ', 'Save Session'],
        \ 'd' : [':DeleteSession', 'Delete Session'],
        \ 'q' : [':CloseSession', 'Close Session'],
    \ }


call which_key#register('<Space>', "g:which_key_map")


"*****************************************************************************
"" Custom configs
"*****************************************************************************
"" better-escape
let g:better_escape_shortcut = ['jk', 'jj', 'kj', 'лл']

"" Sneak
let g:sneak#label = 1

set timeoutlen=500

let g:comfortable_motion_scroll_down_key = "j"
let g:comfortable_motion_scroll_up_key = "k"

"*****************************************************************************
"*****************************************************************************

"" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

"*****************************************************************************
"" Convenience variables
"*****************************************************************************

" vim-airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

if !exists('g:airline_powerline_fonts')
  let g:airline#extensions#tabline#left_sep = ' '
  let g:airline#extensions#tabline#left_alt_sep = '|'
  let g:airline_left_sep          = '▶'
  let g:airline_left_alt_sep      = '»'
  let g:airline_right_sep         = '◀'
  let g:airline_right_alt_sep     = '«'
  let g:airline#extensions#branch#prefix     = '⤴' "➔, ➥, ⎇
  let g:airline#extensions#readonly#symbol   = '⊘'
  let g:airline#extensions#linecolumn#prefix = '¶'
  let g:airline#extensions#paste#symbol      = 'ρ'
  let g:airline_symbols.linenr    = '␊'
  let g:airline_symbols.branch    = '⎇'
  let g:airline_symbols.paste     = 'ρ'
  let g:airline_symbols.paste     = 'Þ'
  let g:airline_symbols.paste     = '∥'
  let g:airline_symbols.whitespace = 'Ξ'
else
  let g:airline#extensions#tabline#left_sep = ''
  let g:airline#extensions#tabline#left_alt_sep = ''

  " powerline symbols
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''
  let g:airline_symbols.branch = ''
  let g:airline_symbols.readonly = ''
  let g:airline_symbols.linenr = ''
endif

"*****************************************************************************
"" multicursor
"****************************************************************************
let g:multi_cursor_use_default_mapping=0

" Default mapping
let g:multi_cursor_start_word_key      = '<C-n>'
let g:multi_cursor_select_all_word_key = '<A-n>'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<A-n>'
let g:multi_cursor_next_key            = '<C-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'


"*****************************************************************************
"" COC
"*****************************************************************************
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>cr <Plug>(coc-rename)

" Formatting selected code
xmap <leader>cF  <Plug>(coc-format-selected)
nmap <leader>cF  <Plug>(coc-format-selected)

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>ca  <Plug>(coc-codeaction-selected)
nmap <leader>ca  <Plug>(coc-codeaction-selected)


" Remap keys for applying refactor code actions
xmap <silent> <leader>cr  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>cr  <Plug>(coc-codeaction-refactor-selected)


" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <leader>sd :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <leader>cl :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <leader>cc  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <leader>co  :<C-u>CocOutline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <leader>cs  :<C-u>CocList symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <leader>cj  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <leader>ck  :<C-u>CocPrev<CR>


