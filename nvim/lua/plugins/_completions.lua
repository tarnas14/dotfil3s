return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
  },
  config = function()
    -- completions
    local cmp = require("cmp")
    local types = require("cmp.types")

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<Tab>"] = cmp.mapping(
          cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert }),
          { "i", "c" }
        ),
        ["<C-j>"] = cmp.mapping(
          cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert }),
          { "i", "c" }
        ),
        ["<S-Tab>"] = cmp.mapping(
          cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert }),
          { "i", "c" }
        ),
        ["<C-k>"] = cmp.mapping(
          cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert }),
          { "i", "c" }
        ),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" }, -- For luasnip users.
      }, {
        { name = "buffer" },
      }),
    })

    cmp.setup.cmdline("/", {
      sources = {
        { name = "buffer" },
      },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })
  end
}
