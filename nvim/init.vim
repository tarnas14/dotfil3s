" general settings
syntax enable
filetype plugin on

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

" moving between splits and tmux panes with the same A-l bindings
let g:tmux_navigator_no_mappings = 1
" terminal mode
nnoremap <silent> <A-z> :TmuxNavigatePrevious<cr>
nnoremap <silent> <A-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <A-j> :TmuxNavigateDown<cr>
nnoremap <silent> <A-k> :TmuxNavigateUp<cr>
nnoremap <silent> <A-l> :TmuxNavigateRight<cr>

" buffer movement/control
nnoremap <C-h> :bprevious<CR>
nnoremap <C-l> :bnext<CR>
nnoremap <C-w> :bdelete<CR>
nnoremap <C-A-w> :bdelete!<CR>

set noshowmode

" Plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'sainnhe/sonokai'

" completions
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer', { 'branch': 'main' }
Plug 'hrsh7th/cmp-nvim-lsp', { 'branch': 'main' }
Plug 'hrsh7th/cmp-buffer', { 'branch': 'main' }
Plug 'hrsh7th/cmp-path', { 'branch': 'main' }
Plug 'hrsh7th/cmp-cmdline', { 'branch': 'main' }
Plug 'hrsh7th/nvim-cmp', { 'branch': 'main' }
" for completions from ultisnip
Plug 'quangnguyen30192/cmp-nvim-ultisnips', { 'branch': 'main' }

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

Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'

Plug 'christoomey/vim-tmux-navigator'

" completions
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" file explorer
Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'

Plug 'kshenoy/vim-signature'

Plug 'lukas-reineke/indent-blankline.nvim'

call plug#end()

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

" completions magic
set completeopt=menu,menuone,noselect

lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'
  local types = require'cmp.types'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert }), { 'i', 'c' }),
      ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert }), { 'i', 'c' }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  local nvim_lsp = require('lspconfig')

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local cmmon_on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  end

  local lsp_installer = require("nvim-lsp-installer")

  lsp_installer.on_server_ready(function (server)
      local opts = {
          on_attach = common_on_attach,
      }

      if server.name == "eslint" then
          opts.on_attach = function (client, bufnr)
              -- neovim's LSP client does not currently support dynamic capabilities registration, so we need to set
              -- the resolved capabilities of the eslint server ourselves!
              client.resolved_capabilities.document_formatting = true
              common_on_attach(client, bufnr)
          end
          opts.settings = {
              format = { enable = true }, -- this will enable formatting
          }
      end

      server:setup(opts)
  end)

  vim.cmd [[highlight IndentBlanklineIndent4 guifg=#383838 gui=nocombine]]
  require("indent_blankline").setup {
      show_end_of_line = false,
      char_highlight_list = {
        "IndentBlanklineIndent4",
    },
  }
EOF

nmap <silent> <leader>g :lua vim.lsp.buf.definition()<CR>
nmap <silent> <leader>i :lua vim.lsp.buf.implementation()<CR>
nmap <silent> K :lua vim.lsp.buf.hover()<CR>
nmap <silent> <C-k> :lua vim.lsp.buf.signature_help()<CR>
nmap <silent> <leader>td :lua vim.lsp.buf.type_definition()<CR>
nmap <silent> <leader>ca :lua vim.lsp.buf.code_action()<CR>
nmap <silent> <leader>r :lua vim.lsp.buf.references()<CR>
nmap <silent> <leader>R :lua vim.lsp.buf.rename()<CR>
nmap <silent> <leader>af :lua vim.lsp.buf.formatting()<CR>
nmap <silent> <leader>ld :lua vim.lsp.diagnostic.show_line_diagnostics()<CR>

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
map <M-p> :Files<CR>
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
noremap <C-_> :call nerdcommenter#Comment(0,"toggle")<CR>
noremap <C-/> :call nerdcommenter#Comment(0,"toggle")<CR>

" PLUGIN matze/vim-move

let g:move_key_modifier = 'C-A'

" PLUG tpope/vim-fugitive
map <leader>gs :Gstatus<CR>
map <leader>gf :Git! diff<CR>
map <leader>gt :Git! diff --staged<CR>
map <leader>gc :Gcommit<CR>
map <leader>gl :Commits<CR>
map <leader>gp :Gpush<CR>

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

" completions
let g:UltiSnipsSnippetDirectories=["~/.config/nvim/UltiSnips", "UltiSnips"]
let g:UltiSnipsExpandTrigger="<C-j>"
let g:UltiSnipsJumpForwardTrigger="<C-l>"
let g:UltiSnipsJumpBackwardTrigger="<C-h>"

" in honor of master Wq
" https://sanctum.geek.nz/arabesque/vim-koans/
command! Wq wq

" close all buffers except the current one
command! Q :%bd|e#
