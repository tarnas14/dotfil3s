" general settings
filetype plugin on
syntax on

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

set relativenumber

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
Plug 'patstockwell/vim-monokai-tasty'
" good light
Plug 'wimstefan/vim-artesanal'
Plug 'endel/vim-github-colorscheme'

" completions
Plug 'williamboman/nvim-lsp-installer'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp', { 'branch': 'main' }
Plug 'hrsh7th/cmp-buffer', { 'branch': 'main' }
Plug 'hrsh7th/cmp-path', { 'branch': 'main' }
Plug 'hrsh7th/cmp-cmdline', { 'branch': 'main' }
Plug 'hrsh7th/nvim-cmp', { 'branch': 'main' }
Plug 'nvim-lua/plenary.nvim'
" for completions from ultisnip
Plug 'quangnguyen30192/cmp-nvim-ultisnips', { 'branch': 'main' }
Plug 'onsails/lspkind.nvim'

Plug 'zbirenbaum/copilot.lua'
Plug 'zbirenbaum/copilot-cmp'

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

Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons' " icons for lualine etc

Plug 'ap/vim-buftabline'

Plug 'mattn/emmet-vim'
" Plug 'pangloss/vim-javascript'

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

Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate'}

Plug 'prisma/vim-prisma'

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

colorscheme vim-monokai-tasty
set background=dark

" colorscheme artesanal
" set background=light

" set completeopt=menu,menuone,noselect
lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'
  local types = require'cmp.types'

  local lspkind = require('lspkind')
  local source_mapping = {
    buffer = "[Buff]",
    nvim_lsp = "[LSP]",
    path = "[Path]",
    copilot = "[Cop]",
  }

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
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
      -- { name = 'copilot' },
      { name = 'nvim_lsp' },
      { name = 'ultisnips' }, -- For ultisnips users.
    }, {
      { name = 'buffer'}
    }),
    formatting = {
      format = function(entry, vim_item)
        -- if you have lspkind installed, you can use it like
        -- in the following line:
        vim_item.kind = lspkind.symbolic(vim_item.kind, {mode = "symbol"})
        vim_item.menu = source_mapping[entry.source.name]
        if entry.source.name == "copilot" then
          local detail = (entry.completion_item.data or {}).detail
          vim_item.kind = "✞"
          if detail and detail:find('.*%%.*') then
            vim_item.kind = vim_item.kind .. ' ' .. detail
          end

          if (entry.completion_item.data or {}).multiline then
            vim_item.kind = vim_item.kind .. ' ' .. '[ML]'
          end
        end
        local maxwidth = 80
        vim_item.abbr = string.sub(vim_item.abbr, 1, maxwidth)
        return vim_item
      end,
    },
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

  require("nvim-lsp-installer").setup {}

  require'lspconfig'.dockerls.setup{}

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  require'lspconfig'.eslint.setup{
   capabilities = capabilities
  }

  capabilities.textDocument.completion.completionItem.snippetSupport = true
  require'lspconfig'.cssls.setup {
    capabilities = capabilities,
  }
  require'lspconfig'.html.setup{
    capabilities = capabilities,
  }
  require'lspconfig'.jsonls.setup {
    capabilities = capabilities,
  }
  require'lspconfig'.tsserver.setup{
    capabilities = capabilities,
  }
  require'lspconfig'.omnisharp.setup{
    capabilities = capabilities,
  }
  require'lspconfig'.elixirls.setup{
      -- cmd = { "/path/to/language_server.sh" };
      cmd = { "/home/tarnas/tools/elixir-ls" };
  }

  vim.cmd [[highlight IndentBlanklineIndent4 guifg=#383838 gui=nocombine]]
  require("indent_blankline").setup {
      show_end_of_line = false,
      char_highlight_list = {
        "IndentBlanklineIndent4",
    },
  }

  -- vim.lsp.set_log_level("debug")

  require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all"
    ensure_installed = { "c_sharp" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    auto_install = true,

    -- List of parsers to ignore installing (for "all")
    ignore_install = { "javascript" },

    highlight = {
      -- `false` will disable the whole extension
      enable = true,

      -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
      -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
      -- the name of the parser)
      -- list of language that will be disabled
      -- disable = { "c", "rust" },

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
      },
    }
EOF

nnoremap <silent> <leader>g :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>i :lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K :lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <C-k> :lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>td :lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <leader>ca :lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>r :lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>R :lua vim.lsp.buf.rename()<CR>
" EslintFixAll is a kinda dirty hack because eslint language server is
" not recognized by vim.lsp.buf.format()
nnoremap <silent> <leader>af :lua vim.lsp.buf.format({ async = true })<CR> :EslintFixAll<CR>
nnoremap <silent> <leader>ld :lua vim.diagnostic.open_float()<CR>

" PLUGIN easymotion/vim-easymotion
" bidirectional character search
map <leader>f <Plug>(easymotion-bd-f)

" PLUGIN itchyny/lightline.vim
" to hide lightline do
" set laststatus=1
let g:lightline = {
      \ 'colorscheme': 'monokai_tasty'
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
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1
" DONT EVEN GET ME STARTED
" apparently command-line vim gets <C-_> when you press ctrl+/
noremap <C-_> :call nerdcommenter#Comment(0,"toggle")<CR>
noremap <C-/> :call nerdcommenter#Comment(0,"toggle")<CR>

" PLUGIN matze/vim-move
let g:move_key_modifier = 'C-A'

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

augroup js_as_ts
  au!
  autocmd BufNewFile,BufRead *.js   set syntax=typescriptreact
augroup END

augroup env_files
  au!
  autocmd BufNewFile,BufRead .env*   set filetype=sh
augroup END

augroup json_files
  au!
  autocmd BufNewFile,BufRead .parcelrc   set syntax=json
augroup END

lua <<EOF
require('lualine').setup({
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    lualine_a = {
      {
        'buffers',
        show_filename_only = true,   -- Shows shortened relative path when set to false.
        hide_filename_extension = false,   -- Hide filename extension when set to true.
        show_modified_status = true, -- Shows indicator when the buffer is modified.

        mode = 0, -- 0: Shows buffer name
        -- 1: Shows buffer index
        -- 2: Shows buffer name + buffer index
        -- 3: Shows buffer number
        -- 4: Shows buffer name + buffer number

        max_length = vim.o.columns * 2, -- Maximum width of buffers component,
        -- it can also be a function that returns
        -- the value of `max_length` dynamically.
        filetype_names = {
          TelescopePrompt = 'Telescope',
          dashboard = 'Dashboard',
          packer = 'Packer',
          fzf = 'FZF',
          alpha = 'Alpha'
        }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )

        -- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
        use_mode_colors = false,
        buffers_color = {
          -- Same values as the general color option can be used here.
          active = 'DiagnosticWarn',     -- Color for active buffer.
        },

        symbols = {
          modified = '[+]',      -- Text to show when the buffer is modified
          alternate_file = '', -- Text to show to identify the alternate file
          directory =  '',     -- Text to show when the buffer is a directory
        },
      }
    }
  },
  winbar = {},
  inactive_winbar = {},
  extensions = {'fzf'}
})
EOF

" lua <<EOF
" require("copilot").setup({
  " suggestion = { enabled = false },
  " panel = { enabled = false },
" })
" require("copilot_cmp").setup()
" EOF
