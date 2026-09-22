# Neovim configuration

Built for Neovim 0.12 on the Arch and Sway machine.
Sync this directory to `~/.config/nvim` and start Neovim once; lazy.nvim installs itself and every plugin, mason installs the language servers and formatters.

## Layout

| Path                         | Holds                                                                   |
| ---------------------------- | ----------------------------------------------------------------------- |
| `init.lua`                   | Leader key and the load order of everything below.                      |
| `lua/config/options.lua`     | Editor options and diagnostic display.                                  |
| `lua/config/clipboard.lua`   | Yank and put through the system clipboard, everything else stays local. |
| `lua/config/keymaps.lua`     | Splits, buffers as tabs, diagnostics, line moving, comments.            |
| `lua/config/autocmds.lua`    | Yank highlight, compose filetype, cursor restore.                       |
| `lua/config/lazy.lua`        | Plugin manager bootstrap.                                               |
| `lua/config/host.lua`        | Per-host settings: reads `/etc/os-release`, loads `<repo>/<id>/nvim/host.lua`. |
| `lua/plugins/*.lua`          | One file per concern, each returns lazy.nvim specs.                     |
| `lua/util/docker_lsp.lua`    | Helper for language servers that run inside a container.                |
| `templates/project.nvim.lua` | Per-project `.nvim.lua` example.                                        |
| `snippets/`                  | Your VS Code style snippets, loaded by LuaSnip.                         |

## System tools it expects

`fzf`, `ripgrep`, `fd`, `yazi`, `wl-clipboard`, `cliphist`, `rofi`, `node` and `npm` for the JavaScript servers, `docker` for the container helper.
`tree-sitter-cli` and a C compiler, because nvim-treesitter builds parser sfrom source
`unzip` because mason extracts most downloaded servers and formatters with it; `:checkhealth mason`
All of them are in the install script of the setup guide.
`claude` for the Claude Code split, from the AUR package `claude-code` or the official installer.
mason downloads language servers and formatters itself.

## Keys

Leader is `,`.
Keys that changed from the old config are marked.

| Key                          | Action                                                                                       |
| ---------------------------- | -------------------------------------------------------------------------------------------- |
| Alt + h j k l                | Move between splits and kitty windows. Changed from Cmd.                                     |
| Ctrl + h, Ctrl + l           | Previous and next buffer.                                                                    |
| Ctrl + w, Ctrl + Alt + w     | Close buffer, close discarding changes. `:Q` closes all others.                              |
| Ctrl + Shift + h j k l       | Resize the current split.                                                                    |
| , \| and , -                 | Split right and below.                                                                       |
| Ctrl + p                     | Files. Changed from Cmd + p.                                                                 |
| Ctrl + Space                 | Buffers.                                                                                     |
| , / and , *                  | Live grep, grep the word under the cursor or the selection.                                  |
| , .                          | Recent files.                                                                                |
| , : and , ? and , k          | Commands, help tags, keymaps.                                                                |
| , E and , e                  | yazi at the current file, yazi at the working directory.                                     |
| , f and , F                  | Flash jump, flash treesitter selection. Replaces pounce.                                     |
| , T                          | Symbols outline. Moved from , t to free the prefix for tests.                                |
| , z                          | Reading mode: no-neck-pain centres the buffer at half the width, wraps, kitty font +2; , T and splits still work; q or Esc leaves. New. |
| , tn, , tf, , ts, , tl, , tv | Test nearest, file, suite, last again, open the last test file. New.                         |
| , cct, , ccf                 | Claude Code: toggle the split, focus it. New.                                                |
| , ccs                        | Claude Code: send the selection. Visual mode. New.                                           |
| , ccb, , ccr, , ccc, , ccm   | Claude Code: add current buffer, resume a session, continue the last one, select model. New. |
| , cca, , ccd                 | Claude Code: accept or deny the proposed diff. New.                                          |
| , C                          | Jump to the enclosing context.                                                               |
| , p                          | Put an entry chosen from the clipboard history. New.                                         |
| y, Y, p, P                   | Yank and put through the system clipboard. d, c and x do not touch it.                       |
| Ctrl + /                     | Toggle comment.                                                                              |
| Ctrl + Alt + j k             | Move line or selection.                                                                      |
| , ld, , dn, , dp, , dd       | Line diagnostics, next, previous, buffer list.                                               |
| , hs, , hr, , hp, , hb, , hB | Stage, reset, preview hunk, blame line, toggle inline blame.                                 |
| ]h and [h                    | Next and previous hunk.                                                                      |
| , rr                         | Refactoring menu.                                                                            |

LSP keys, active once a server attaches:

| Key                    | Action                                                                          |
| ---------------------- | ------------------------------------------------------------------------------- |
| , g and , d            | Definition, declaration.                                                        |
| K                      | Hover.                                                                          |
| , i                    | Implementation.                                                                 |
| Ctrl + k               | Signature help.                                                                 |
| Space D                | Type definition.                                                                |
| , R                    | Rename.                                                                         |
| , ca                   | Code actions, listed in fzf.                                                    |
| , r, , s, , S          | References, document symbols, workspace symbols.                                |
| , ih                   | Toggle inlay hints.                                                             |
| , af                   | Format the buffer.                                                              |
| , oi, , am, , ru, , fa | TypeScript only: organize imports, add missing imports, remove unused, fix all. |
| , ef                   | ESLint fix all.                                                                 |

Insert mode: Enter accepts the highlighted completion, Tab and Ctrl + j / Ctrl + k move through the list, Ctrl + Space opens it, Ctrl + ; expands a snippet, Ctrl + l and Ctrl + h jump between snippet fields.

## Language servers

mason installs the servers listed in `lua/plugins/lsp.lua` on first start and mason-lspconfig enables everything installed.
Adding a server is two steps: `:Mason`, pick it, then add an entry to the `servers()` table only if it needs settings.
`:LspInfo` shows what is attached to the current buffer, `:checkhealth vim.lsp` shows problems.

Stacks covered out of the box:

| Stack                  | Servers and formatters                                                                                        |
| ---------------------- | ------------------------------------------------------------------------------------------------------------- |
| TypeScript, JavaScript | vtsls, eslint, prettierd, emmet, tailwindcss                                                                  |
| Python                 | basedpyright for types and hover, ruff for lint, imports and formatting                                       |
| Elixir                 | expert, `mix format` on save. Replace with elixirls in both lists of `lsp.lua` if mason does not know expert. |
| Lua                    | lua_ls with Neovim types through lazydev, stylua                                                              |
| Others                 | json and yaml with schemas, dockerfile, compose, bash, markdown, html, css                                    |

## A server inside a container

The project must be bind-mounted at the same path inside the container as on the host.
Then copy `templates/project.nvim.lua` to the project root as `.nvim.lua`, adjust the service name and the server command, and trust the file when Neovim asks.
The helper builds a `docker exec` or `docker compose exec` command and Neovim speaks to the server over stdio as if it were local.
A server that listens on a published TCP port is one line instead: `vim.lsp.config("name", { cmd = vim.lsp.rpc.connect("127.0.0.1", 9000) })`.

## Tests

vim-test runs the nearest test, the current file or the whole suite in a terminal split at the bottom that is reused for every run.
It detects jest, vitest, pytest and ExUnit from the project.
For a suite that only runs inside a container, set the runner executable in the project's `.nvim.lua`, as shown in `templates/project.nvim.lua`.

## Claude Code

`,cct` opens the CLI in a split on the right.
Select code and `,ccs` sends it as context, `,ccb` adds the whole buffer.
When Claude proposes a change it opens as a diff, `,cca` accepts and `,ccd` rejects.
The CLI has to be logged in once from a terminal before the first use.

## Clipboard behaviour

`clipboard` is empty on purpose.
`y` and `p` are mapped to the `+` register, so every yank reaches Wayland and therefore cliphist, and `p` pastes whatever cliphist last put on the clipboard.
Deletes and changes stay inside Neovim, which keeps the ten-entry history clean.
`,p` opens the history in rofi from inside Neovim.

## kitty side of the navigator

The plugin copies its kittens into `~/.config/kitty` on install.
kitty needs these lines so Alt + hjkl reaches Neovim when it has focus and moves kitty windows otherwise:

```
allow_remote_control yes
listen_on unix:@mykitty
map alt+h kitten pass_keys.py left   alt+h
map alt+j kitten pass_keys.py bottom alt+j
map alt+k kitten pass_keys.py top    alt+k
map alt+l kitten pass_keys.py right  alt+l
```

## Dropped from the old config, and why

- nvim-cmp became blink.cmp, faster and less configuration for the same keys.
- fzf.vim became fzf-lua, same feel plus LSP pickers.
- neo-tree became yazi.nvim, the same file manager as the terminal.
- pounce became flash.nvim, nerdcommenter became the built-in `gc`, vim-cursorword became mini.cursorword, nvim-bufdel became mini.bufremove, mini.diff became gitsigns.
- nvim-lint is gone: eslint and ruff run as language servers now.
- emmet-vim is gone: emmet runs as a language server and completes through blink.
- lsp-status and the legacy fidget tag are gone: lualine has an `lsp_status` component and fidget is current.
- toggleterm is gone, kitty panes do that job.
- The CODEOWNERS check in the TypeScript import action was specific to one repository on the Mac and is not carried over.
- CodeCompanion keymaps were left over from a plugin that was no longer installed.
- `.cs_files` was a YouCompleteMe artefact.

## First run checklist

1. `:Lazy` shows every plugin installed, `:Mason` shows every server and formatter installed.
2. `:checkhealth` has no errors under vim.lsp, vim.treesitter and fzf-lua.
3. Open a TypeScript file, `,r` on a symbol lists references in fzf.
4. Yank a line, Super + c on the desktop shows it in the clipboard history.
5. `,E` opens yazi with the current file selected.
6. Alt + l from the leftmost split ends up in the kitty window to the right.
