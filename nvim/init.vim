" general settings

syntax enable
set number
set hidden
set nocompatible

set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=0
set autoindent
set smartindent

" set listchars+=space:.
" set list

set nobackup
set noswapfile

" adds padding to the buffer display (so cursor will not reach the end)
set scrolloff=3

" folds
set foldmethod=syntax
set foldlevelstart=20

" splits
set splitbelow
set splitright

" system clipboard
set clipboard+=unnamedplus

" Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

let mapleader=","

nnoremap <leader>\| :vsplit<CR>
nnoremap <leader>- :split<CR>

nnoremap <A-L> <C-W><C-L>
nnoremap <A-H> <C-W><C-H>
nnoremap <A-K> <C-W><C-K>
nnoremap <A-J> <c-W><C-J>

" buffer movement/control
nnoremap <C-h> :bprevious<CR>
nnoremap <C-l> :bnext<CR>
nnoremap <C-w> :bdelete<CR>
nnoremap <C-A-w> :bdelete!<CR>

set noshowmode

" Plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'sainnhe/sonokai'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'easymotion/vim-easymotion'
Plug 'Raimondi/delimitMate'
Plug 'scrooloose/nerdcommenter'
Plug 'matze/vim-move'
Plug 'editorconfig/editorconfig-vim'
Plug 'itchyny/vim-cursorword'

Plug 'sheerun/vim-polyglot'

Plug 'tpope/vim-fugitive'

Plug 'itchyny/lightline.vim'
Plug 'ap/vim-buftabline'

Plug 'mattn/emmet-vim'
Plug 'pangloss/vim-javascript'

Plug 'w0rp/ale'

Plug 'tarnas14/workflowish', {'for': 'workflowish'}

Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'

" writing prose
Plug 'junegunn/goyo.vim'

" completions
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'ycm-core/YouCompleteMe', { 'do': 'python3 ./install.py --ts-completer --go-completer' }

" file explorer
Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'

Plug 'kshenoy/vim-signature'

call plug#end()

" nmap <leader>/ <Plug>AgRawSearch
" vmap <leader>/ <Plug>AgRawVisualSelection
" nmap <leader>. <Plug>AgRawWordUnderCursor

" Turn off linewise keys. Normally, the `j' and `k' keys move the cursor down one entire line. with
" line wrapping on, this can cause the cursor to actually skip a few lines on the screen because
" it's moving from line N to line N+1 in the file. I want this to act more visually -- I want `down'
" to mean the next line on the screen
nmap j gj
nmap k gk

" COLOURS

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
  if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif

colorscheme sonokai
set background=dark

" PLUGIN easymotion/vim-easymotion
" bidirectional character search
map <leader>f <Plug>(easymotion-bd-f)

" PLUGIN itchyny/lightline.vim
" to hide lightline do `set laststatus=1`
let g:lightline = {
      \ 'colorscheme': 'sonokai'
      \ }

" fzf
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>, fzf#vim#with_preview('right:50%'), <bang>0)
map <leader>* "ayiw:call fzf#vim#ag('<C-r>a', fzf#vim#with_preview('right:50%'))<CR>
map <C-p> :Files<CR>
map <C-k> :Files<CR>
map <C-space> :Buffers<CR>
map <leader>/ :Ag<CR>
map <leader>l :BLines<CR>

" Default fzf layout
"
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" In Neovim, you can set up fzf window using a Vim command
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10split enew' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" PLUG 'ap/vim-buftabline'
let g:buftabline_indicators = 1

" PLUGIN scrooloose/nerdcommenter
"
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" DONT EVEN GET ME STARTED
" apparently command-line vim gets <C-_> when you press ctrl+/
noremap <C-_> :call NERDComment(0,"toggle")<CR>
noremap <C-/> :call NERDComment(0,"toggle")<CR>

" PLUGIN matze/vim-move

let g:move_key_modifier = 'C-A'

" PLUGIN w0rp/ale

let g:ale_linters = {
\  'javascript': ['flow', 'eslint'],
\  'typescript': ['tslint'],
\  'elixir': ['mix'],
\  'go': ['golint']
\}
let g:ale_fixers = {
\  'javascript': ['eslint'],
\  'elixir': ['mix_format'],
\  'go': ['gofmt'],
\}

highlight clear ALEWarningSign " otherwise uses error bg color (typically red)
let g:ale_statusline_format = ['X %d', '? %d', '']
" %linter% is the name of the linter that provided the message
" %s is the error or warning message
let g:ale_echo_msg_format = '%linter% says %s'
" Map keys to navigate between lines with errors and warnings.
nnoremap <leader>an :ALENextWrap<cr>
nnoremap <leader>ap :ALEPreviousWrap<cr>
nnoremap <leader>af :ALEFix<cr>

" PLUG tpope/vim-fugitive
map <leader>gs :Gstatus<CR>
map <leader>gf :Git! diff<CR>
map <leader>gt :Git! diff --staged<CR>
map <leader>gc :Gcommit<CR>
map <leader>gl :Commits<CR>
map <leader>gp :Gpush<CR>

" PLUG tarnas14/workflowish
nnoremap <leader>t :TT<CR>
nnoremap <leader>r :TTr<CR>
nnoremap <leader>p :P<CR>
nnoremap <leader>a :A<CR>
nnoremap <leader>T :Today<CR>
nnoremap <leader>R :Tomorrow<CR>

" Plug 'francoiscabrol/ranger.vim'
let g:ranger_map_keys = 0
let g:ranger_replace_netrw = 1 " open ranger when vim open a direct

" map file reload
nnoremap <leader>e :e!<CR>
nnoremap <leader>E :Ranger<CR>

" disable arrows
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

command! -nargs=1 R :silent !tmux send-keys -t right <f-args> <C-m>

" remove trailing whitespace
autocmd BufWritePre * %s/\s\+$//e

" set filetypes
au BufRead,BufNewFile *.jsx set filetype=javascript.jsx
au BufRead,BufNewFile *.tsx set filetype=typescript.jsx " PLUG peitalin/vim-jsx-typescript

" completions
let g:UltiSnipsSnippetDirectories=["~/.config/nvim/UltiSnips", "UltiSnips"]
let g:UltiSnipsExpandTrigger="<C-j>"
let g:UltiSnipsJumpForwardTrigger="<C-l>"
let g:UltiSnipsJumpBackwardTrigger="<C-h>"
