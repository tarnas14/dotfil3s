-- Claude Code inside Neovim. The CLI runs in a right-hand split, sees the
-- current selection and open buffers, and proposes edits as diffs you accept
-- or deny without leaving the editor. Needs the `claude` binary on PATH:
-- `yay -S claude-code` or the official installer.
--
-- Keys keep the old CodeCompanion prefix: ,cc followed by one letter.
return {
  "coder/claudecode.nvim",
  cmd = { "ClaudeCode", "ClaudeCodeFocus", "ClaudeCodeSend", "ClaudeCodeAdd", "ClaudeCodeStatus" },
  opts = {
    terminal = { provider = "native", split_side = "right", split_width_percentage = 0.35 },
    diff_opts = { auto_close_on_accept = true, vertical_split = true },
  },
  keys = {
    { "<leader>cct", "<cmd>ClaudeCode<cr>", desc = "claude: toggle" },
    { "<leader>ccf", "<cmd>ClaudeCodeFocus<cr>", desc = "claude: focus" },
    { "<leader>ccr", "<cmd>ClaudeCode --resume<cr>", desc = "claude: resume a session" },
    { "<leader>ccc", "<cmd>ClaudeCode --continue<cr>", desc = "claude: continue last session" },
    { "<leader>ccm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "claude: select model" },
    { "<leader>ccb", "<cmd>ClaudeCodeAdd %<cr>", desc = "claude: add current buffer" },
    { "<leader>ccs", "<cmd>ClaudeCodeSend<cr>", mode = "x", desc = "claude: send selection" },
    { "<leader>cca", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "claude: accept diff" },
    { "<leader>ccd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "claude: deny diff" },
  },
}
