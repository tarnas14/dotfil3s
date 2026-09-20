-- nvim-treesitter on its main branch: it only installs parsers now, Neovim's own
-- vim.treesitter does the highlighting. Missing parsers are installed on first
-- use of a filetype; highlighting starts the next time such a file is opened.

local ensure = {
  "bash", "c", "css", "diff", "dockerfile", "eex", "elixir", "erlang", "gitcommit", "git_rebase",
  "heex", "html", "javascript", "jsdoc", "json", "jsonc", "lua", "luadoc", "markdown", "markdown_inline",
  "prisma", "python", "query", "regex", "scss", "sql", "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup({})
      ts.install(ensure)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        callback = function(ev)
          --terminals, prompst and plugin window shave no code tohighligt
          if vim.bo[ev.buf].buftype ~= "" then
            return
          end
          -- "yaml.docker-compose" and friends: the parser belongs to the first part
          local ft = ev.match:match("^[^.]+")
          local lang = vim.treesitter.language.get_lang(ft) or ft
          local ok, added = pcall(vim.treesitter.language.add, lang)
          if not (ok and added) then
            local available = {}
            pcall(function()
              available = ts.get_available()
            end)
            if vim.list_contains(available, lang) then
              pcall(ts.install, { lang })
            end
            return
          end
          pcall(vim.treesitter.start, ev.buf, lang)
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    opts = { max_lines = 4 },
    keys = {
      {
        "<leader>C",
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end,
        desc = "go to context",
      },
    },
  },
  -- closes and renames tags in tsx, html and heex
  { "windwp/nvim-ts-autotag", event = "InsertEnter", opts = {} },
}
