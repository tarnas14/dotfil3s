require("utils")
-- util functions

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.autoindent = true
vim.opt.shiftwidth = 0
vim.opt.smartindent = true
vim.opt.relativenumber = true
vim.opt.number = true

vim.g.mapleader = ","

-- in honor of master Wq
-- https://sanctum.geek.nz/arabesque/vim-koans/
vim.cmd("command! Wq wq")

-- use global clipboard for vim
-- TODO check if there is a better one that does not put everything (only y, p)
vim.opt.clipboard:append({ "unnamedplus" })

-- splits
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.keymap.set("n", "<leader>|", vimCmd("vsplit"))
vim.keymap.set("n", "<leader>-", vimCmd("split"))
vim.keymap.set("n", "C-S-l", vimCmd("vertical-resize -5"))
vim.keymap.set("n", "C-S-h", vimCmd("vertical-resize +5"))

-- buffer movement / control
vim.keymap.set("n", "<C-h>", vimCmd("bprevious"), { silent = true })
vim.keymap.set("n", "<C-l>", vimCmd("bnext"), { silent = true })

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<leader>dd", vim.diagnostic.setloclist)

-- fzf
vim.keymap.set("n", "<D-p>", vimCmd("Files"))
vim.keymap.set("n", "<C-space>", vimCmd("Buffers"))
vim.keymap.set("n", "<leader>/", vimCmd("Ag"))
vim.keymap.set("n", "<leader>*", vimCmd(":call fzf#vim#ag(expand('<cword>'), fzf#vim#with_preview('right:50%'))"))
-- map <leader>l :BLines<CR>

-- moving lines
vim.keymap.set("n", "<C-A-j>", vimCmd("m .+1<CR>=="))
vim.keymap.set("n", "<C-A-k>", vimCmd("m .-2<CR>=="))
vim.keymap.set("v", "<C-A-j>", ":m '>+1<CR>gv=gv") -- cannot use vimCmd because it does not work otherwise :3
vim.keymap.set("v", "<C-A-k>", ":m '<-2<CR>gv=gv") -- cannot use vimCmd because it does not work otherwise :3

require("config/lazy")
