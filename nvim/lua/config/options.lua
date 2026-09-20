local o = vim.opt

-- indentation: two spaces everywhere, shiftwidth follows tabstop
o.expandtab = true
o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 0
o.autoindent = true
o.smartindent = true

-- ui
o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.cursorline = true
o.scrolloff = 6
o.termguicolors = true
o.splitbelow = true
o.splitright = true
o.showmode = false

-- behaviour
o.ignorecase = true
o.smartcase = true
o.undofile = true
o.updatetime = 250
o.timeoutlen = 500
o.mouse = "a"
o.completeopt = { "menu", "menuone", "noselect" }

-- per-project .nvim.lua at the repository root; Neovim asks once to trust it.
-- Used for container-backed language servers, see lua/util/docker_lsp.lua
o.exrc = true

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = { spacing = 2, prefix = "●" },
  float = { border = "rounded", source = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
})

-- in honor of master Wq
vim.cmd("command! Wq wq")
