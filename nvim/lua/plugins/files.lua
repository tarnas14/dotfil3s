-- yazi inside Neovim: the same file manager and keys as in the terminal, in a floating window.
return {
  "mikavilpas/yazi.nvim",
  version = "*",
  event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>E", "<cmd>Yazi<cr>", mode = { "n", "x" }, desc = "yazi at current file" },
    { "<leader>e", "<cmd>Yazi cwd<cr>", desc = "yazi at working directory" },
  },
  init = function()
    -- yazi handles `nvim somedir` instead of netrw
    vim.g.loaded_netrwPlugin = 1
  end,
  opts = {
    open_for_directories = true,
    keymaps = { show_help = "<f1>" },
  },
}
