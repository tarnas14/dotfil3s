" general settings

set number
set hidden
set nocompatible

set expandtab
set tabstop=2
set shiftwidth=0
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
Plug 'flazz/vim-colorschemes'

Plug 'vim-ctrlspace/vim-ctrlspace'
Plug 'easymotion/vim-easymotion'

Plug 'vim-airline/vim-airline'
Plug 'edkolev/tmuxline.vim'

Plug 'Valloric/YouCompleteMe'

Plug 'scrooloose/syntastic'
Plug 'jelera/vim-javascript-syntax'
call plug#end()
" colorschemes

colorscheme molokai

" airline config
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" vim-easymotion configuration
" bidirectional character search
map <leader>f <Plug>(easymotion-bd-f)

" ctrl-space config
nnoremap <silent><C-p> :CtrlSpace O<CR>
if executable("ag")
  let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
endif

" syntastic

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
