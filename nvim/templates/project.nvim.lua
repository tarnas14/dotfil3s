-- Copy this file to the root of a project as `.nvim.lua`.
-- Neovim sources it on startup because `exrc` is on, and asks you once to trust it (:trust).
--
-- Example: the Elixir server runs inside the app container, which has the
-- project bind-mounted at the same path as on the host.
local docker = require("util.docker_lsp")

vim.lsp.config("expert", docker.compose("web", { "expert", "--stdio" }))

-- TypeScript server from a container that owns node_modules:
-- vim.lsp.config("vtsls", docker.compose("web", { "vtsls", "--stdio" }))

-- Tests inside the container. vim-test only builds a command line, so pointing
-- the runner at docker is enough. Pick the lines for the stacks the project has.
vim.g["test#javascript#jest#executable"] = "docker compose exec -T web npx jest"
-- vim.g["test#javascript#runner"] = "vitest"
-- vim.g["test#javascript#vitest#executable"] = "docker compose exec -T web npx vitest"
-- vim.g["test#python#pytest#executable"] = "docker compose exec -T api pytest"
-- vim.g["test#elixir#exunit#executable"] = "docker compose exec -T web mix test"

-- Per-project formatting preferences work here too:
-- vim.b.autoformat = false
