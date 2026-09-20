-- Alt+hjkl moves between Neovim splits and kitty windows as one space.
-- The build step copies the navigator kittens into ~/.config/kitty; the kitty
-- side of the mapping is in the README.
vim.g.kitty_navigator_no_mappings = 1

return {
  {
    "MunsMan/kitty-navigator.nvim",
    build = {
      "cp navigate_kitty.py ~/.config/kitty",
      "cp pass_keys.py ~/.config/kitty",
    },
    keys = {
      {
        "<A-h>",
        function()
          require("kitty-navigator").navigateLeft()
        end,
        desc = "Move left a Split",
        mode = { "n" },
      },
      {
        "<A-j>",
        function()
          require("kitty-navigator").navigateDown()
        end,
        desc = "Move down a Split",
        mode = { "n" },
      },
      {
        "<A-k>",
        function()
          require("kitty-navigator").navigateUp()
        end,
        desc = "Move up a Split",
        mode = { "n" },
      },
      {
        "<A-l>",
        function()
          require("kitty-navigator").navigateRight()
        end,
        desc = "Move right a Split",
        mode = { "n" },
      },
    },
  },
  {
    -- open kitty's scrollback in Neovim
    "mikesmithgh/kitty-scrollback.nvim",
    version = "*",
    lazy = true,
    cmd = {
      "KittyScrollbackGenerateKittens",
      "KittyScrollbackCheckHealth",
      "KittyScrollbackGenerateCommandLineEditing",
    },
    event = { "User KittyScrollbackLaunch" },
    opts = {},
  },
}
