-- Only yank and put touch the system clipboard. Deletes, changes and x stay in
-- Neovim's own registers, so cliphist's history holds what you meant to copy
-- and nothing else. Neovim finds wl-copy/wl-paste on its own under Wayland.
vim.opt.clipboard = ""

local map = vim.keymap.set

map({ "n", "x" }, "y", '"+y', { desc = "yank to clipboard" })
map("n", "Y", '"+y$', { desc = "yank to end of line to clipboard" })
map({ "n", "x" }, "p", '"+p', { desc = "put from clipboard" })
map({ "n", "x" }, "P", '"+P', { desc = "put before from clipboard" })

-- Pick an entry from the clipboard history through rofi and put it at the cursor.
-- ~/.local/bin/rofi-clip --print speaks to cliphist on sway and to GPaste on GNOME.
map("n", "<leader>p", function()
  local out = vim.fn.system("rofi-clip --print")
  if vim.v.shell_error ~= 0 or out == "" then
    return
  end
  vim.fn.setreg("+", out)
  vim.cmd('normal! "+p')
end, { desc = "put from clipboard history" })
