-- Focused reading: the buffer alone in a centred column half the terminal wide,
-- numbers and signs off, prose wrapped, the rest dimmed. ,z toggles.
-- kitty's font grows two points while it is on: zen-mode talks to kitty through
-- KITTY_LISTEN_ON, which kitty exports because kitty.conf sets listen_on.
-- For plain shell output the kitty side has the same idea on Alt+a Shift+z
-- (kitty/reading_mode.py); use one or the other, not both at once.
return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "reading mode" } },
  opts = {
    window = {
      width = 0.5,
      height = 1,
      backdrop = 0.95,
      options = {
        signcolumn = "no",
        number = false,
        relativenumber = false,
        cursorline = false,
        foldcolumn = "0",
        list = false,
      },
    },
    plugins = {
      options = { enabled = true, ruler = false, showcmd = false, laststatus = 0 },
      gitsigns = { enabled = true },
      kitty = { enabled = true, font = "+2" },
    },
    on_open = function(win)
      vim.wo[win].wrap = true
      vim.wo[win].linebreak = true
      vim.wo[win].breakindent = true
    end,
  },
}
