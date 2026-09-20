return {
  {
    "L3MON4D3/LuaSnip",
    version = "2.*",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      local ls = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })

      vim.keymap.set("i", "<C-;>", function()
        ls.expand()
      end, { silent = true, desc = "expand snippet" })
      vim.keymap.set({ "i", "s" }, "<C-l>", function()
        ls.jump(1)
      end, { silent = true, desc = "next snippet field" })
      vim.keymap.set({ "i", "s" }, "<C-h>", function()
        ls.jump(-1)
      end, { silent = true, desc = "previous snippet field" })
      vim.keymap.set({ "i", "s" }, "<C-e>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { silent = true, desc = "next snippet choice" })
    end,
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "L3MON4D3/LuaSnip" },
    opts = {
      -- same keys as the old nvim-cmp setup: Enter accepts the highlighted item,
      -- Tab and Ctrl+j/k move through the list
      keymap = {
        preset = "none",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      },
      snippets = { preset = "luasnip" },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      completion = {
        list = { selection = { preselect = true, auto_insert = false } },
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        menu = { draw = { treesitter = { "lsp" } } },
      },
      signature = { enabled = true },
      cmdline = {
        enabled = true,
        keymap = {
          preset = "cmdline",
          ["<C-j>"] = { "select_next", "fallback" },
          ["<C-k>"] = { "select_next", "fallback" },
        },
        completion = { menu = { auto_show = true }, list = { selection = { preselect = false, auto_insert = true } } },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
