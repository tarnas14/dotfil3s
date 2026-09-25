-- Yanks and deletes both reach the system clipboard, so text cut here can be
-- pasted into another window and p puts back whatever was last yanked, deleted
-- or copied elsewhere. Neovim finds wl-copy/wl-paste on its own under Wayland.
--
-- The cost is that the clipboard history fills with deletes as well as copies;
-- raise GPaste's max-history-size if ten entries stop being enough.
vim.opt.clipboard = "unnamedplus"

-- Pick an entry from the clipboard history through rofi and put it at the cursor.
-- ~/.local/bin/rofi-clip --print speaks to cliphist on sway and to GPaste on GNOME.
vim.keymap.set("n", "<leader>p", function()
  local out = vim.fn.system("rofi-clip --print")
  if vim.v.shell_error ~= 0 or out == "" then
    return
  end
  vim.fn.setreg("+", out)
  vim.cmd('normal! "+p')
end, { desc = "put from clipboard history" })
