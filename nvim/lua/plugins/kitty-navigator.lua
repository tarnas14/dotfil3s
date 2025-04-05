vim.g.kitty_navigator_no_mappings = 1

return {
  "knubie/vim-kitty-navigator",
  build = "cp ./*.py ~/.config/kitty/",
  config = function()
    -- Cmd+H is remapped in karabiner to send Cmd+Esc to the system, because hiding windows under Cmd+H cannot be disabled
    vim.keymap.set("n", "<D-Esc>", vimCmd("KittyNavigateLeft"), { silent = true })
    vim.keymap.set("n", "<D-l>", vimCmd("KittyNavigateRight"), { silent = true })
    vim.keymap.set("n", "<D-j>", vimCmd("KittyNavigateDown"), { silent = true })
    vim.keymap.set("n", "<D-k>", vimCmd("KittyNavigateUp"), { silent = true })
  end,
}
