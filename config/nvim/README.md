# Neovim config

Go-focused setup for Neovim 0.12+, built on native APIs where possible.

## Layout

- `init.lua` — leaders + loads `lua/config/*`
- `lua/config/pack.lua` — plugins via built-in `vim.pack` (lockfile: `nvim-pack-lock.json`)
- `lua/config/lsp.lua` — `vim.lsp.config` / `vim.lsp.enable`; `lsp/gopls.lua` for gopls
- `lua/config/completion.lua` — `vim.lsp.completion` + `vim.snippet`
- `lua/config/format.lua` — format on save (Go: gopls organize imports + gofumpt; SQL: sqlfluff)
- `lua/config/go.lua` — tests (gotestsum), golangci-lint, alternate file
- `lua/config/terminal.lua`, `lua/config/ui.lua` — float terminal, `vim.ui.select`
- `after/plugin/*.lua` — per-plugin settings
- `after/ftplugin/go.lua` — Go keymaps and `:GoReplace*` rewrite commands
- `after/queries/go/injections.scm` — SQL highlighting in `// sql`-marked raw strings

## Plugins

`:lua vim.pack.update()` → review → `:write`. Treesitter parsers update along with it.

fzf-lua, oil (`-`), yazi (`//`), gitsigns, treesitter (+textobjects, context),
which-key, lualine, mason, nvim-dap (+go), render-markdown, grpc-nvim,
vim-surround, vim-tmux-navigator, theme.nvim (ilyasyoy-mono) + auto-dark-mode.

## Theme

`ilyasyoy-mono` from [IlyasYOY/theme.nvim](https://github.com/IlyasYOY/theme.nvim):
monochrome, dark/light palette follows macOS Appearance via auto-dark-mode.
Override: `NVIM_BACKGROUND=dark|light`.

## Keys (leader `Space`, localleader `,`)

| Keys | Action |
|---|---|
| `<leader>ff` `<leader>/` `<leader>fr` | files / grep / resume (fzf-lua) |
| `<leader>fs` `<leader>fS` `<leader>dd` | symbols / workspace symbols / diagnostics |
| `gd` `grr` `gri` `grD` | definition / references / implementations / declaration |
| `grn` `gra` `K` | rename / code action / hover (Neovim defaults) |
| `<leader>tt/tf/tn/tw` | Go tests: package / file / function / watch |
| `,gl` `,gq` | golangci-lint in terminal / to quickfix |
| `,ga` | `foo.go` ↔ `foo_test.go` |
| `-` `<leader>e` `//` | oil / oil float / yazi |
| `<leader>gg` | lazygit |
| `<C-t>` | float terminal |
| `<C-j>/<C-k>`, `<CR>`, `<Tab>` | completion next/prev, confirm, snippet jump |

Path completion: `<C-x><C-f>`.
