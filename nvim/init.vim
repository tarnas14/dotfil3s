" general settings

syntax on
set number
set hidden
set nocompatible

set expandtab
set tabstop=2
set shiftwidth=0
set autoindent
set smartindent

set listchars+=space:.
set list

set nobackup
set noswapfile

" folds
set foldmethod=syntax
set foldlevelstart=20

" splits
set splitbelow
set splitright

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

" Plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'rakr/vim-one'
Plug 'vim-ctrlspace/vim-ctrlspace'
Plug 'easymotion/vim-easymotion'
Plug 'Raimondi/delimitMate'
Plug 'vim-airline/vim-airline'
Plug 'edkolev/tmuxline.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'matze/vim-move'
Plug 'editorconfig/editorconfig-vim'
Plug 'itchyny/vim-cursorword'

Plug 'mattn/emmet-vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx', {'for': 'javascript.jsx'}

Plug 'Valloric/YouCompleteMe', { 'do': './install.py --tern-completer' }

" Potentially will be used, needs more testing of typescript and flow :)
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'mhartington/nvim-typescript', { 'do': ':UpdateRemotePlugins' }
" Plug 'wokalski/autocomplete-flow'

Plug 'w0rp/ale'

Plug 'leafgarland/typescript-vim', {'for': 'typescript'}
Plug 'peitalin/vim-jsx-typescript'

Plug 'tarnas14/workflowish', {'for': 'workflowish'}

Plug 'itchyny/calendar.vim'
call plug#end()

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

set background=dark
colorscheme one

" PLUGIN vim-ctrlspace/vim-ctrlspace

nnoremap <silent><C-p> :CtrlSpace O<CR>
nnoremap <leader>r :call ctrlspace#files#RefreshFiles()<CR>
if executable("ag")
  let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
endif
" the setting below is a workaround proposed to bug in https://github.com/vim-ctrlspace/vim-ctrlspace/issues/188
let g:CtrlSpaceDefaultMappingKey = "<C-space> "

" PLUGIN vim-airline/vim-airline
let g:airline#extensions#tabline#enabled = 1

" PLUGIN easymotion/vim-easymotion
" bidirectional character search
map <leader>f <Plug>(easymotion-bd-f)

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
\  'typescript': ['tslint']
\}
highlight clear ALEWarningSign " otherwise uses error bg color (typically red)
let g:ale_statusline_format = ['X %d', '? %d', '']
" %linter% is the name of the linter that provided the message
" %s is the error or warning message
let g:ale_echo_msg_format = '%linter% says %s'
" Map keys to navigate between lines with errors and warnings.
nnoremap <leader>an :ALENextWrap<cr>
nnoremap <leader>ap :ALEPreviousWrap<cr>

" PLUG Shougo/deoplete
" let g:deoplete#enable_at_startup=1
" inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" PLUG peitalin/vim-jsx-typescript
autocmd BufNewFile,BufRead *.tsx set filetype=typescript.jsx

" PLUG itchyny/calendar.vim
let g:calendar_google_calendar = 1
command! Cal Calendar -view=week
command! Calm Calendar -view=month
