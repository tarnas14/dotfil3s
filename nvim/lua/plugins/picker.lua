-- fzf-lua: the fzf.vim workflow with LSP pickers. Needs fzf, ripgrep and fd on the system.
return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "FzfLua",
  opts = {
    "default-title",
    winopts = {
      height = 0.85,
      width = 0.85,
      preview = { layout = "vertical", vertical = "up:55%" },
    },
    files = { cwd_prompt = false },
    grep = { rg_glob = true },
  },
  config = function(_, opts)
    local fzf = require("fzf-lua")
    fzf.setup(opts)
    -- code actions and other vim.ui.select prompts open in fzf too
    fzf.register_ui_select()
  end,
  keys = {
    {
      "<A-p>",
      function()
        require("fzf-lua").files()
      end,
      desc = "files",
    },
    {
      "<C-space>",
      function()
        require("fzf-lua").buffers()
      end,
      desc = "buffers",
    },
    {
      "<leader>.",
      function()
        require("fzf-lua").oldfiles()
      end,
      desc = "recent files",
    },
    {
      "<leader>/",
      function()
        require("fzf-lua").live_grep()
      end,
      desc = "live grep",
    },
    {
      "<leader>*",
      function()
        require("fzf-lua").grep_cword()
      end,
      desc = "grep word under cursor",
    },
    {
      "<leader>*",
      function()
        require("fzf-lua").grep_visual()
      end,
      mode = "x",
      desc = "grep selection",
    },
    {
      "<leader>:",
      function()
        require("fzf-lua").commands()
      end,
      desc = "commands",
    },
    {
      "<leader>?",
      function()
        require("fzf-lua").helptags()
      end,
      desc = "help tags",
    },
    {
      "<leader>k",
      function()
        require("fzf-lua").keymaps()
      end,
      desc = "keymaps",
    },
  },
}
