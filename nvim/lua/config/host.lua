-- Per-host settings. ~/.config/nvim is one symlink into the shared repository, so a
-- host file inside it would be shared too; instead read the distribution id from
-- /etc/os-release and load <repo>/<id>/nvim/host.lua (arch/nvim/host.lua, ubuntu/nvim/host.lua).
local M = {}

function M.id()
  local f = io.open("/etc/os-release")
  if not f then
    return nil
  end
  local s = f:read("*a")
  f:close()
  return s:match('\nID="?([%w_.-]+)') or s:match('^ID="?([%w_.-]+)')
end

--- @return table  the host file's table, or {} when there is none
function M.config()
  local id = M.id()
  local real = vim.uv.fs_realpath(vim.fn.stdpath("config"))
  if not (id and real) then
    return {}
  end
  local ok, cfg = pcall(dofile, vim.fs.dirname(real) .. "/" .. id .. "/nvim/host.lua")
  return (ok and type(cfg) == "table") and cfg or {}
end

return M
