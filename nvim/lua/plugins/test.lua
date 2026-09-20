-- vim-test: run the nearest test, the file or the suite in one reusable
-- terminal split. It only builds a command line, which is what makes running
-- inside a container a one-line override per project, see templates/project.nvim.lua.
return {
  "vim-test/vim-test",
  cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast", "TestVisit" },
  keys = {
    { "<leader>tn", "<cmd>TestNearest<cr>", desc = "test nearest" },
    { "<leader>tf", "<cmd>TestFile<cr>", desc = "test file" },
    { "<leader>ts", "<cmd>TestSuite<cr>", desc = "test suite" },
    { "<leader>tl", "<cmd>TestLast<cr>", desc = "test last again" },
    { "<leader>tv", "<cmd>TestVisit<cr>", desc = "open last test file" },
  },
  init = function()
    -- one terminal split at the bottom, reused and cleared for every run
    vim.g["test#strategy"] = "neovim_sticky"
    vim.g["test#neovim_sticky#kill_previous"] = 1
    vim.g["test#neovim_sticky#reopen_window"] = 1
    vim.g["test#neovim#term_position"] = "botright 15"
    -- "kitty" instead runs each test in a new kitty window next to Neovim
  end,
}
