return {
  { "kylechui/nvim-surround", version = "^3.0.0", event = "VeryLazy", opts = {} },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  {
    -- jump anywhere on screen by typing a few characters, replaces pounce
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>f", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "flash jump" },
      { "<leader>F", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "flash treesitter select" },
    },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    cmd = "Refactor",
    opts = {},
    keys = {
      { "<leader>rr", mode = { "n", "x" }, function() require("refactoring").select_refactor() end, desc = "refactor" },
    },
  },
  { "chentoast/marks.nvim", event = "VeryLazy", opts = {} },
  { "kevinhwang91/nvim-bqf", ft = "qf" },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", event = "VeryLazy", opts = { scope = { enabled = false } } },
  -- highlights other occurrences of the word under the cursor, replaces vim-cursorword
  { "echasnovski/mini.cursorword", version = "*", event = "VeryLazy", opts = {} },
  -- close buffers without breaking the window layout, used by <C-w> in keymaps.lua
  { "echasnovski/mini.bufremove", version = "*", lazy = true },
}
