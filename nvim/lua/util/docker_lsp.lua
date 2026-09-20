-- Run a language server inside a running container.
--
-- Neovim talks to the server over stdio exactly as it would locally, only the
-- process runs in the container. The one requirement: the project must be
-- mounted at the same path inside the container as on the host, because the
-- server receives host file paths and has to find the same files.
--
-- Use it from a project's .nvim.lua (see templates/project.nvim.lua):
--
--   local docker = require("util.docker_lsp")
--   vim.lsp.config("expert", docker.exec("myapp-web-1", { "expert", "--stdio" }))
--   vim.lsp.config("vtsls", docker.compose("web", { "vtsls", "--stdio" }))
--
-- A server that listens on a TCP port you published instead:
--
--   vim.lsp.config("expert", { cmd = vim.lsp.rpc.connect("127.0.0.1", 9000) })

local M = {}

--- @param container string running container name or id
--- @param cmd string[] server command as it would be typed inside the container
--- @param extra table|nil additional vim.lsp.config fields to merge in
function M.exec(container, cmd, extra)
  local full = { "docker", "exec", "-i", container }
  vim.list_extend(full, cmd)
  return vim.tbl_deep_extend("force", { cmd = full }, extra or {})
end

--- Same as exec, addressing a docker compose service from the project directory.
--- @param service string compose service name
--- @param cmd string[]
--- @param extra table|nil
function M.compose(service, cmd, extra)
  local full = { "docker", "compose", "exec", "-T", service }
  vim.list_extend(full, cmd)
  return vim.tbl_deep_extend("force", { cmd = full }, extra or {})
end

return M
