return {
  { "tpope/vim-fugitive", cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Gblame" } },
  { "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" } },
  {
    -- signs, hunk navigation, staging and blame; replaces mini.diff
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
      on_attach = function(buf)
        local gs = require("gitsigns")
        local function m(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
        end
        m("n", "]h", function() gs.nav_hunk("next") end, "next hunk")
        m("n", "[h", function() gs.nav_hunk("prev") end, "previous hunk")
        m({ "n", "x" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", "stage hunk")
        m({ "n", "x" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", "reset hunk")
        m("n", "<leader>hp", gs.preview_hunk_inline, "preview hunk")
        m("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "blame line")
        m("n", "<leader>hB", gs.toggle_current_line_blame, "toggle inline blame")
      end,
    },
  },
}
