return {
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		lazy = false,
		config = function()
			require("refactoring").setup()
		end,
	},
	{
		"kylechui/nvim-surround",
		version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	{
		"olimorris/onedarkpro.nvim",
		lazy = false,
		priority = 9001,
		config = function()
			vim.opt.background = "dark"
			vim.cmd("colorscheme onedark")
			vim.api.nvim_create_user_command("Light", function()
				vim.opt.background = ""
				vim.cmd("colorscheme onelight")
			end, {})
			vim.api.nvim_create_user_command("Dark", function()
				vim.opt.background = "dark"
				vim.cmd("colorscheme onedark")
			end, {})
		end,
	},
	-- this is configured correctly, but most language servers don't send it :(
	{
		-- nvim notifications (e.g. bottom right lsp loading)
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = "LspAttach",
		opts = {
			-- options
		},
	},
	{
		"mfussenegger/nvim-lint",
		build = "npm i -g eslint_d",
		config = function()
			require("lint").linters_by_ft = {
				lua = { "luacheck" },
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				typescriptreact = { "eslint_d" },
			}
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"rafamadriz/friendly-snippets",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
		config = function()
			local ls = require("luasnip")
			vim.keymap.set({ "i" }, "<C-;>", function()
				ls.expand()
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-l>", function()
				ls.jump(1)
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-h>", function()
				ls.jump(-1)
			end, { silent = true })

			vim.keymap.set({ "i", "s" }, "<C-e>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end, { silent = true })

			require("luasnip.loaders.from_vscode").lazy_load({ paths = "./snippets" })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"elixir",
					"heex",
					"eex",
					"yaml",
					"c_sharp",
					"dockerfile",
					"javascript",
					"typescript",
					"tsx",
					"markdown",
				},
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
				require("treesitter-context").go_to_context(vim.v.count1)
			end, { silent = true })
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		config = function()
			vim.keymap.set("n", "<leader>E", vimCmd("Neotree reveal"))
		end,
	},
	{ "junegunn/fzf", build = ":call fzf#install()" },
	"junegunn/fzf.vim",
	{
		"rlane/pounce.nvim",
		config = function()
			vim.keymap.set("n", "<leader>f", vimCmd("Pounce"), { silent = true })
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {}, -- this is eqivualent to setup({}) function
	},
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
	"itchyny/vim-cursorword",
	"tpope/vim-fugitive",
	"mattn/emmet-vim",
	{
		"ojroques/nvim-bufdel",
		lazy = false,
		config = function()
			require("bufdel").setup()
			vim.keymap.set("n", "<C-w>", vimCmd("BufDel"), { silent = true })
			vim.keymap.set("n", "<C-A-w>", vimCmd("BufDel!"), { silent = true })
			-- close all buffers except the current one
			vim.cmd("command! Q :BufDelOthers")
		end,
	},
  { 'echasnovski/mini.diff', version = '*' },
  { 'kevinhwang91/nvim-bqf' },
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
