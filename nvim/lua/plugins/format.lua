-- Formatting on save through conform. Language servers are the fallback when no
-- formatter is listed for a filetype. :FormatToggle switches save-formatting off
-- for a session, vim.b.autoformat = false switches it off per buffer or project.
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettierd" },
      javascriptreact = { "prettierd" },
      typescript = { "prettierd" },
      typescriptreact = { "prettierd" },
      json = { "prettierd" },
      jsonc = { "prettierd" },
      yaml = { "prettierd" },
      markdown = { "prettierd" },
      css = { "prettierd" },
      scss = { "prettierd" },
      html = { "prettierd" },
      python = { "ruff_organize_imports", "ruff_format" },
      elixir = { "mix" },
      eelixir = { "mix" },
      heex = { "mix" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      ["_"] = { "trim_whitespace" },
    },
    default_format_opts = { lsp_format = "fallback" },
    format_on_save = function(buf)
      if vim.g.autoformat == false or vim.b[buf].autoformat == false then
        return
      end
      return { timeout_ms = 1000, lsp_format = "fallback" }
    end,
    notify_on_error = true,
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    vim.api.nvim_create_user_command("FormatToggle", function()
      vim.g.autoformat = vim.g.autoformat == false
      vim.notify("format on save: " .. tostring(vim.g.autoformat ~= false))
    end, { desc = "toggle format on save" })
  end,
}
