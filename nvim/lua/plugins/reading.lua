-- Focused reading with room to navigate. no-neck-pain centres the buffer between
-- two padding windows, so aerial (,T), splits and quickfix keep working; zen-mode's
-- single float closed the moment another window took focus, which made ,T useless.
-- ,z toggles, q or Escape leaves. While it is on: numbers, signs and statusline off, prose wrapped,
-- kitty's font two points bigger (through KITTY_LISTEN_ON, exported because
-- kitty.conf sets listen_on). For plain shell output the kitty side has the same
-- idea on Alt+a Shift+z (kitty/reading_mode.py); use one or the other, not both.

local saved = {} -- per main window: the options to put back on disable
local font_bumped = false
local exit_keys = { "q", "<Esc>" } -- leave the mode with either, mapped only while it is on
local exit_maps = {} -- what those keys were before, restored on disable

local function kitty_font(size)
  local sock = vim.env.KITTY_LISTEN_ON
  if not sock or sock == "" or vim.fn.executable("kitten") ~= 1 then
    return
  end
  vim.fn.jobstart({ "kitten", "@", "--to", sock, "set-font-size", size }, { detach = true })
  font_bumped = size ~= "0"
end

local reading = {
  number = false,
  relativenumber = false,
  signcolumn = "no",
  cursorline = false,
  wrap = true,
  linebreak = true,
  breakindent = true,
}

local function main_win(state)
  local ok, win = pcall(function()
    return state:get_side_id("curr")
  end)
  if ok and win and vim.api.nvim_win_is_valid(win) then
    return win
  end
  return vim.api.nvim_get_current_win()
end

local function enter(state)
  local win = main_win(state)
  saved[win] = { laststatus = vim.o.laststatus }
  for k, v in pairs(reading) do
    saved[win][k] = vim.wo[win][k]
    vim.wo[win][k] = v
  end
  vim.o.laststatus = 0
  for _, lhs in ipairs(exit_keys) do
    local prev = vim.fn.maparg(lhs, "n", false, true)
    exit_maps[lhs] = (prev.lhs and prev.buffer == 0) and prev or false
    vim.keymap.set("n", lhs, "<cmd>NoNeckPain<cr>", { desc = "leave reading mode" })
  end
  kitty_font("+2")
end

local function leave(state)
  local win = main_win(state)
  local s = saved[win]
  if not s then
    local _, any = next(saved) -- main window went away: restore from whatever we saved
    s = any
  end
  saved = {}
  if s then
    vim.o.laststatus = s.laststatus
    if vim.api.nvim_win_is_valid(win) then
      for k, v in pairs(s) do
        if k ~= "laststatus" then
          vim.wo[win][k] = v
        end
      end
    end
  end
  for lhs, prev in pairs(exit_maps) do
    pcall(vim.keymap.del, "n", lhs)
    if prev then
      vim.fn.mapset("n", false, prev)
    end
  end
  exit_maps = {}
  kitty_font("0")
end

-- quitting nvim while reading mode is on would leave kitty's font enlarged
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    if font_bumped and vim.env.KITTY_LISTEN_ON and vim.fn.executable("kitten") == 1 then
      vim.fn.system({ "kitten", "@", "--to", vim.env.KITTY_LISTEN_ON, "set-font-size", "0" })
    end
  end,
})

return {
  "shortcuts/no-neck-pain.nvim",
  version = "*",
  cmd = { "NoNeckPain", "NoNeckPainResize", "NoNeckPainScratchPad" },
  keys = { { "<leader>z", "<cmd>NoNeckPain<cr>", desc = "reading mode" } },
  opts = function()
    return {
      -- half the terminal, in columns: the plugin has no fraction setting. :NoNeckPainResize N changes it live.
      width = math.floor(vim.o.columns / 2),
      minSideBufferWidth = 10,
      -- Alt+hjkl and friends never land in a padding window
      autocmds = { skipEnteringNoNeckPainBuffer = true },
      -- ,T opens aerial on the right; the text stays centred in the space that is left
      integrations = { aerial = { position = "right", reopen = true } },
      callbacks = { postEnable = enter, preDisable = leave },
    }
  end,
}
