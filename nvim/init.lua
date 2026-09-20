-- Entry point. Leader first, then options, then plugins.
vim.g.mapleader = ","
vim.g.maplocalleader = ","

require("config.options")
require("config.clipboard")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
