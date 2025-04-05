
	return {
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"nvim-lua/lsp-status.nvim",
		},
    config = function()
      require("lualine").setup({
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "diagnostics" },
          lualine_c = {},
          lualine_x = { "aerial", "filetype", "require'lsp-status'.status()" },
          lualine_y = {},
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {
          lualine_a = {
            {
              "buffers",
              show_filename_only = true, -- Shows shortened relative path when set to false.
              hide_filename_extension = false, -- Hide filename extension when set to true.
              show_modified_status = true, -- Shows indicator when the buffer is modified.

              mode = 0, -- 0: Shows buffer name
              -- 1: Shows buffer index
              -- 2: Shows buffer name + buffer index
              -- 3: Shows buffer number
              -- 4: Shows buffer name + buffer number

              max_length = vim.o.columns * 2, -- Maximum width of buffers component,
              -- it can also be a function that returns
              -- the value of `max_length` dynamically.
              filetype_names = {
                dashboard = "Dashboard",
                packer = "Packer",
                fzf = "FZF",
                alpha = "Alpha",
              }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )

              -- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
              use_mode_colors = false,
              buffers_color = {
                -- Same values as the general color option can be used here.
                active = "DiagnosticWarn", -- Color for active buffer.
              },

              symbols = {
                modified = "[+]", -- Text to show when the buffer is modified
                alternate_file = "", -- Text to show to identify the alternate file
                directory = "", -- Text to show when the buffer is a directory
              },
            },
          },
        },
        winbar = {},
        inactive_winbar = {},
        extensions = { "fzf" },
      })
    end
	}
