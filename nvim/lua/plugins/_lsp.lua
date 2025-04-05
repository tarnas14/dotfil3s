-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
		-- local client = vim.lsp.get_client_by_id(ev.data.client_id)
		-- client.name ~= "ts_ls"
		-- client.name == "ts_ls"

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "<leader>d", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "<leader>g", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>i", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<leader>R", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>r", vim.lsp.buf.references, opts)
		-- we have a custom one in ts_ls
		vim.keymap.set("n", "<leader>af", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
	end,
})

return {
	{
		"neovim/nvim-lspconfig",
		build = "npm install -g dockerfile-language-server-nodejs @microsoft/compose-language-service typescript-language-server typescript",
    config = function()
      -- Set up lspconfig language servers LSP
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local function ts_ls_organize_imports()
        vim.lsp.buf.execute_command({
          command = "_typescript.organizeImports",
          arguments = { vim.api.nvim_buf_get_name(0) },
          title = "",
        })
      end

      local function ts_ls_add_missing_imports()
        vim.lsp.buf.code_action({
          apply = true,
          context = {
            ---@diagnostic disable-next-line: assign-type-mismatch
            only = { "source.addMissingImports.ts" },
            diagnostics = {},
          },
        })
      end

      local function ts_ls_fix_all()
        vim.lsp.buf.code_action({
          apply = true,
          context = {
            ---@diagnostic disable-next-line: assign-type-mismatch
            only = { "source.fixAll.ts" },
            diagnostics = {},
          },
        })
      end

      local function ts_ls_remove_unused()
        vim.lsp.buf.code_action({
          apply = true,
          context = {
            ---@diagnostic disable-next-line: assign-type-mismatch
            only = { "source.removeUnused.ts" },
            diagnostics = {},
          },
        })
      end

      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        on_attach = function()
          vim.keymap.set("n", "<leader>oi", ts_ls_organize_imports, opts)
          vim.keymap.set("n", "<leader>am", function()
            ts_ls_add_missing_imports()
            ts_ls_organize_imports()
          end, opts)
          vim.keymap.set("n", "<leader>ru", ts_ls_remove_unused, opts)
          vim.keymap.set("n", "<leader>fa", function()
            ts_ls_add_missing_imports()
            ts_ls_organize_imports()
            ts_ls_remove_unused()
            ts_ls_fix_all()
          end, opts)
        end,
        init_options = {
          hostInfo = "neovim",
          preferences = {
            importModuleSpecifierPreference = "shortest",
          },
        },
      })

      lspconfig.dockerls.setup({
        capabilities = capabilities,
      })

      lspconfig.docker_compose_language_service.setup({})
      -- set filetype for docker-compose files to load this lsp
      vim.filetype.add({
        filename = {
          ["docker-compose.yml"] = "yaml.docker-compose",
          ["docker-compose.yaml"] = "yaml.docker-compose",
        },
      })
    end
	},
	{ "williamboman/mason-lspconfig.nvim", config = true },
	{
		"williamboman/mason.nvim",
		config = true,
	},
}
