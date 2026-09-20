local map = vim.keymap.set

-- splits: Alt+hjkl moves between splits and kitty windows (see plugins/kitty.lua)
map("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "split right" })
map("n", "<leader>-", "<cmd>split<cr>", { desc = "split below" })
map("n", "<C-S-h>", "<cmd>vertical resize +5<cr>", { desc = "widen split" })
map("n", "<C-S-l>", "<cmd>vertical resize -5<cr>", { desc = "narrow split" })
map("n", "<C-S-k>", "<cmd>resize +3<cr>", { desc = "taller split" })
map("n", "<C-S-j>", "<cmd>resize -3<cr>", { desc = "shorter split" })

-- buffers act as tabs, listed in the lualine tabline
map("n", "<C-h>", "<cmd>bprevious<cr>", { silent = true, desc = "previous buffer" })
map("n", "<C-l>", "<cmd>bnext<cr>", { silent = true, desc = "next buffer" })
map("n", "<C-w>", function()
  require("mini.bufremove").delete(0, false)
end, { desc = "close buffer" })
map("n", "<C-A-w>", function()
  require("mini.bufremove").delete(0, true)
end, { desc = "close buffer, discard changes" })
vim.api.nvim_create_user_command("Q", function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.bo[buf].buflisted then
      require("mini.bufremove").delete(buf, false)
    end
  end
end, { desc = "close all other buffers" })

-- diagnostics
map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "line diagnostics" })
map("n", "<leader>dn", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "next diagnostic" })
map("n", "<leader>dp", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "previous diagnostic" })
map("n", "<leader>dd", function()
  require("fzf-lua").diagnostics_document()
end, { desc = "buffer diagnostics" })

-- move lines
map("n", "<C-A-j>", ":m .+1<CR>==", { silent = true, desc = "move line down" })
map("n", "<C-A-k>", ":m .-2<CR>==", { silent = true, desc = "move line up" })
map("x", "<C-A-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "move selection down" })
map("x", "<C-A-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "move selection up" })

-- comments: Neovim's built-in gc on the key you are used to; <C-_> is what some terminals send for Ctrl+/
map("n", "<C-/>", "gcc", { remap = true, desc = "toggle comment" })
map("x", "<C-/>", "gc", { remap = true, desc = "toggle comment" })
map("n", "<C-_>", "gcc", { remap = true })
map("x", "<C-_>", "gc", { remap = true })

-- copy the current file path
vim.api.nvim_create_user_command("BufferPath", function()
  vim.fn.setreg("+", vim.fn.expand("%"))
  vim.notify("relative path copied")
end, { desc = "copy relative file path to clipboard" })
vim.api.nvim_create_user_command("BufferPathAbsolute", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
  vim.notify("absolute path copied")
end, { desc = "copy absolute file path to clipboard" })
