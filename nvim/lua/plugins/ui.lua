return {
  {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      vim.cmd.colorscheme("onedark")
      vim.api.nvim_create_user_command("Dark", function()
        vim.o.background = "dark"
        vim.cmd.colorscheme("onedark")
      end, {})
      vim.api.nvim_create_user_command("Light", function()
        vim.o.background = "light"
        vim.cmd.colorscheme("onelight")
      end, {})
      -- warm brown and orange scheme that matches the desktop palette
      vim.api.nvim_create_user_command("Warm", function()
        vim.o.background = "dark"
        vim.cmd.colorscheme("melange")
      end, {})
    end,
  },
  { "savq/melange-nvim", lazy = false, priority = 999 },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = { globalstatus = true, section_separators = "", component_separators = "│" },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "lsp_status", "aerial", "filetype" },
        lualine_y = {},
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "location" },
      },
      -- open buffers shown as tabs, cycled with Ctrl+h and Ctrl+l
      tabline = {
        lualine_a = {
          {
            "buffers",
            show_filename_only = true,
            mode = 0,
            max_length = function()
              return vim.o.columns * 2
            end,
            buffers_color = { active = "DiagnosticWarn" },
            symbols = { modified = " [+]", alternate_file = "", directory = "" },
          },
        },
      },
      extensions = { "fzf", "aerial", "quickfix", "lazy", "mason" },
    },
  },
  {
    "stevearc/aerial.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {},
    -- ,T rather than ,t so the test runner can own the ,t prefix
    keys = { { "<leader>T", "<cmd>AerialToggle<cr>", desc = "symbols outline" } },
  },
  -- LSP progress in the corner, replaces the legacy fidget tag and lsp-status
  { "j-hui/fidget.nvim", event = "LspAttach", opts = {} },
  -- shows the mappings behind a prefix while you hesitate; also :FzfLua keymaps
  { "folke/which-key.nvim", event = "VeryLazy", opts = { preset = "helix", delay = 400 } },
  { "yousefhadder/markdown-plus.nvim", ft = "markdown", opts = {} },
}
