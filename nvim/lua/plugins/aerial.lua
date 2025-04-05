require("utils")

vim.keymap.set("n", "<leader>a", vimCmd("AerialToggle"))

return {
  'stevearc/aerial.nvim',
  opts = {},
  -- Optional dependencies
  dependencies = {
     "nvim-treesitter/nvim-treesitter",
     "nvim-tree/nvim-web-devicons"
  },
}
