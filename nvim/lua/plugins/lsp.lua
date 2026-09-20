-- Language servers. mason installs them, mason-lspconfig enables everything
-- that is installed, and the overrides below are applied with the native
-- vim.lsp.config API. Container-backed servers: lua/util/docker_lsp.lua.

local function bmap(buf, mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc, silent = true })
end

local function code_action(kinds)
  return function()
    vim.lsp.buf.code_action({ apply = true, context = { only = kinds, diagnostics = {} } })
  end
end

-- keymaps every server gets
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
  callback = function(ev)
    local fzf = require("fzf-lua")
    local buf = ev.buf
    bmap(buf, "n", "<leader>d", vim.lsp.buf.declaration, "declaration")
    bmap(buf, "n", "<leader>g", vim.lsp.buf.definition, "definition")
    bmap(buf, "n", "K", vim.lsp.buf.hover, "hover")
    bmap(buf, "n", "<leader>i", vim.lsp.buf.implementation, "implementation")
    bmap(buf, "n", "<C-k>", vim.lsp.buf.signature_help, "signature help")
    bmap(buf, "n", "<space>D", vim.lsp.buf.type_definition, "type definition")
    bmap(buf, "n", "<space>wa", vim.lsp.buf.add_workspace_folder, "add workspace folder")
    bmap(buf, "n", "<space>wr", vim.lsp.buf.remove_workspace_folder, "remove workspace folder")
    bmap(buf, "n", "<space>wl", function()
      vim.print(vim.lsp.buf.list_workspace_folders())
    end, "list workspace folders")
    bmap(buf, "n", "<leader>R", vim.lsp.buf.rename, "rename")
    bmap(buf, { "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "code action")
    bmap(buf, "n", "<leader>r", fzf.lsp_references, "references")
    bmap(buf, "n", "<leader>s", fzf.lsp_document_symbols, "document symbols")
    bmap(buf, "n", "<leader>S", fzf.lsp_live_workspace_symbols, "workspace symbols")
    bmap(buf, "n", "<leader>ih", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
    end, "toggle inlay hints")
    bmap(buf, "n", "<leader>af", function()
      require("conform").format({ async = true, lsp_format = "fallback" })
    end, "format buffer")
  end,
})

-- per-server overrides; anything not listed runs with nvim-lspconfig defaults
local function servers()
  local schemastore = require("schemastore")
  return {
    vtsls = {
      settings = {
        complete_function_calls = true,
        vtsls = { autoUseWorkspaceTsdk = true },
        typescript = {
          updateImportsOnFileMove = { enabled = "always" },
          preferences = { importModuleSpecifier = "shortest" },
          inlayHints = {
            parameterNames = { enabled = "literals" },
            functionLikeReturnTypes = { enabled = true },
          },
        },
        javascript = {
          updateImportsOnFileMove = { enabled = "always" },
          preferences = { importModuleSpecifier = "shortest" },
        },
      },
      on_attach = function(_, buf)
        bmap(buf, "n", "<leader>oi", code_action({ "source.organizeImports", "source.organizeImports.ts" }), "organize imports")
        bmap(buf, "n", "<leader>am", code_action({ "source.addMissingImports.ts" }), "add missing imports")
        bmap(buf, "n", "<leader>ru", code_action({ "source.removeUnused.ts" }), "remove unused")
        bmap(buf, "n", "<leader>fa", code_action({ "source.fixAll.ts" }), "fix all")
      end,
    },
    eslint = {
      settings = { workingDirectories = { mode = "auto" } },
      on_attach = function(_, buf)
        bmap(buf, "n", "<leader>ef", code_action({ "source.fixAll.eslint" }), "eslint fix all")
      end,
    },
    basedpyright = {
      settings = {
        basedpyright = { analysis = { typeCheckingMode = "standard", autoImportCompletions = true } },
      },
    },
    ruff = {
      -- basedpyright owns hover, ruff owns lint and format
      on_attach = function(client)
        client.server_capabilities.hoverProvider = false
      end,
    },
    jsonls = {
      settings = { json = { schemas = schemastore.json.schemas(), validate = { enable = true } } },
    },
    yamlls = {
      settings = {
        yaml = { schemaStore = { enable = false, url = "" }, schemas = schemastore.yaml.schemas() },
      },
    },
    emmet_language_server = {
      filetypes = { "html", "css", "scss", "javascriptreact", "typescriptreact", "heex", "eelixir" },
    },
    -- expert is the Elixir team's language server. If mason does not know it
    -- yet on your registry version, replace it with elixirls in both lists.
    expert = {},
  }
end

return {
  { "mason-org/mason.nvim", opts = { ui = { border = "rounded" } } },
  {
    -- formatters and other tools that are not language servers
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = { ensure_installed = { "prettierd", "stylua", "shfmt" } },
  },
  { "b0o/SchemaStore.nvim", lazy = true },
  {
    -- Neovim runtime types for lua_ls while editing this config
    "folke/lazydev.nvim",
    ft = "lua",
    opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "b0o/SchemaStore.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
      for name, cfg in pairs(servers()) do
        vim.lsp.config(name, cfg)
      end
      require("mason-lspconfig").setup({
        automatic_enable = true,
        ensure_installed = {
          "vtsls",
          "eslint",
          "basedpyright",
          "ruff",
          "expert",
          "lua_ls",
          "jsonls",
          "yamlls",
          "dockerls",
          "docker_compose_language_service",
          "bashls",
          "tailwindcss",
          "emmet_language_server",
          "marksman",
          "html",
          "cssls",
        },
      })
    end,
  },
}
