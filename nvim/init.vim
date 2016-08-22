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

Plug 'scrooloose/syntastic'

Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'Valloric/YouCompleteMe'

Plug 'scrooloose/nerdcommenter'
Plug 'matze/vim-move'
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

" PLUGIN vim-airline/vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" PLUGIN easymotion/vim-easymotion
" bidirectional character search
map <leader>f <Plug>(easymotion-bd-fj

" PLUGIN vim-ctrlspace/vim-ctrlspace
nnoremap <silent><C-p> :CtrlSpace O<CR>
nnoremap <leader>r :call ctrlspace#files#RefreshFiles()<CR>
if executable("ag")
  let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
endif

" PLUGIN scrooloose/syntastic

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_javascript_checkers = ['eslint']

let g:syntastic_error_symbol = '❌'
let g:syntastic_style_error_symbol = '⁉️'
let g:syntastic_warning_symbol = '⚠️'
let g:syntastic_style_warning_symbol = '💩'

highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn

" PLUGIN scrooloose/nerdcommenter
"
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" DONT EVEN GET ME STARTED
" apparently vim gets <C-_> when you press ctrl+/
nnoremap <C-_> :call NERDComment(0,"toggle")<CR>
vnoremap <C-_> :call NERDComment(0,"toggle")<CR>

" PLUGIN matze/vim-move

let g:move_key_modifier = 'C-A'

