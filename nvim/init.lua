vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 0
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.g.mapleader = ","

-- use global clipboard for vim
-- TODO check if there is a better one that does not put everything (only y, p)
vim.opt.clipboard:append({ "unnamedplus" })

-- splits
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.keymap.set("n", "<leader>|", ":vsplit<CR>")
vim.keymap.set("n", "<leader>-", ":split<CR>")

vim.opt.relativenumber = true

-- buffer movement / control
vim.keymap.set("n", "<C-h>", ":bprevious<CR>", { silent = true })
vim.keymap.set("n", "<C-l>", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<C-w>", ":bdelete<CR>", { silent = true })
vim.keymap.set("n", "<C-A-w>", ":bdelete!<CR>", { silent = true })

-- package manager

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.move_key_modifier = "A-C"

require("lazy").setup({
	{
		"olimorris/onedarkpro.nvim",
		lazy = false,
		priority = 9001,
		config = function()
			vim.opt.background = "dark"
			vim.cmd("colorscheme onedark")
		end,
	},
	"neovim/nvim-lspconfig",
	{ "williamboman/mason.nvim", config = true },
	{ "williamboman/mason-lspconfig.nvim", config = true },
	{
		"mhartington/formatter.nvim",
		config = function()
			vim.keymap.set("n", "<leader>af", ":Format<CR>", { silent = true })
			vim.keymap.set("n", "<leader>aF", ":FormatWrite<CR>", { silent = true })
			local opts = {
				filetype = {
					lua = {
						require("formatter.filetypes.lua").stylua,
					},
					["*"] = {
						require("formatter.filetypes.any").remove_trailing_whitespace,
					},
				},
			}
			require("formatter").setup(opts)
		end,
	},
	{
		"mfussenegger/nvim-lint",
		config = function()
			require("lint").linters_by_ft = {
				lua = { "luacheck" },
			}

			-- not sure if all these events are needed
			vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			vim.keymap.set("n", "<leader>C", function()
				require("treesitter-context").go_to_context()
			end, { silent = true })
		end,
	},
	{
		"kevinhwang91/rnvimr",
		config = function()
			vim.keymap.set("n", "<leader>E", ":RnvimrToggle<CR>", { silent = true })
			vim.g.rnvimr_enable_ex = 1
			vim.g.rnvimr_enable_picker = 1
			vim.g.rnvimr_hide_gitignore = 1
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},
	{ "junegunn/fzf", build = "fzf#install()" },
	"junegunn/fzf.vim",
	{
		"rlane/pounce.nvim",
		config = function()
			vim.keymap.set("n", "<leader>f", ":Pounce<CR>", { silent = true })
		end,
	},
	{
		"preservim/nerdcommenter",
		config = function()
			vim.keymap.set({ "n", "v" }, "<C-/>", ':call nerdcommenter#Comment(0,"toggle")<CR>', { silent = true })
			vim.g.NERDSpaceDelims = 1
		end,
	},
	{
		"drybalka/tree-climber.nvim",
		config = function()
			local keyopts = { noremap = true, silent = true }
			vim.keymap.set({ "n", "v", "o" }, "H", require("tree-climber").goto_parent, keyopts)
			vim.keymap.set({ "n", "v", "o" }, "L", require("tree-climber").goto_child, keyopts)
			vim.keymap.set({ "n", "v", "o" }, "J", require("tree-climber").goto_next, keyopts)
			vim.keymap.set({ "n", "v", "o" }, "K", require("tree-climber").goto_prev, keyopts)
			vim.keymap.set("n", "<c-a-s-k>", require("tree-climber").swap_prev, keyopts)
			vim.keymap.set("n", "<c-a-s-j>", require("tree-climber").swap_next, keyopts)
			vim.keymap.set("n", "<leader>h", require("tree-climber").highlight_node, keyopts)
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {}, -- this is eqivualent to setup({}) function
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup({
				-- for example, context is off by default, use this to turn it on
				show_current_context = true,
				show_current_context_start = true,
			})
		end,
	},
	"tpope/vim-surround",
	"itchyny/vim-cursorword",
  'sheerun/vim-polyglot',
})

-- LSP

require("mason-lspconfig").setup()

-- Setup language servers.
local lspconfig = require("lspconfig")
lspconfig.tsserver.setup({})

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<space>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
	end,
})

-- completions
require("cmp").setup()

-- statusline / tabline
require("lualine").setup({
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = { "encoding", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {
		lualine_a = {
			{
				"buffers",
				show_filename_only = true, -- Shows shortened relative path when set to false.
				hide_filename_extension = false, -- Hide filename extension when set to true.
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
					TelescopePrompt = "Telescope",
					dashboard = "Dashboard",
					packer = "Packer",
					fzf = "FZF",
					alpha = "Alpha",
				}, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )

				-- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
				use_mode_colors = false,
				buffers_color = {
					-- Same values as the general color option can be used here.
					active = "DiagnosticWarn", -- Color for active buffer.
				},

				symbols = {
					modified = "[+]", -- Text to show when the buffer is modified
					alternate_file = "", -- Text to show to identify the alternate file
					directory = "", -- Text to show when the buffer is a directory
				},
			},
		},
	},
	winbar = {},
	inactive_winbar = {},
	extensions = { "fzf" },
})

-- fzf
vim.keymap.set("n", "<M-p>", ":Files<CR>")
-- map <C-space> :Buffers<CR>
-- map <leader>/ :Ag<CR>
-- map <leader>l :BLines<CR>

-- moving lines
vim.keymap.set("n", "<C-A-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<C-A-k>", ":m .-2<CR>==")
vim.keymap.set("v", "<C-A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<C-A-k>", ":m '<-2<CR>gv=gv")
