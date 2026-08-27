# Native Neovim APIs — replace redundant plugins

Date: 2026-08-20  
Scope: Neovim 0.12 config under `dotfiles/nvim`  
Approach: native config modules + slim plugin specs (option B migration)

## Goal

Remove plugins whose behavior is covered by built-in Neovim 0.12 APIs, without dropping Telescope fuzzy UX, Mason as a binary installer, or treesitter as a parser installer.

## Decisions

| Topic | Choice |
|-------|--------|
| Migration scope | B — lspconfig/mason-lspconfig/trouble out; cmp → `vim.lsp.completion`; toggleterm → native terminal; telescope-ui-select → `vim.ui.select`; treesitter stays as installer |
| Snippets | `vim.snippet`, remove LuaSnip |
| Mason | Keep `mason.nvim` UI; no `mason-lspconfig` auto-install |
| Layout | New `lua/config/{completion,terminal,ui}.lua` modules |

## Remove

- `neovim/nvim-lspconfig`
- `williamboman/mason-lspconfig.nvim`
- `hrsh7th/nvim-cmp`, `cmp-nvim-lsp`, `cmp-path`, `saadparwaiz1/cmp_luasnip`
- `L3MON4D3/LuaSnip`
- `akinsho/toggleterm.nvim`
- `nvim-telescope/telescope-ui-select.nvim`
- `folke/trouble.nvim`

## Keep (unchanged role)

Mason, Telescope + fzf-native, nvim-treesitter (installer + existing `vim.treesitter.start`), which-key, lualine, yazi, gitsigns, lazygit, gitlab (+ deps), overseer, markdown-preview, render-markdown, grpc-nvim, vim-surround, vim-tmux-navigator, kanagawa, auto-dark-mode, plenary/nui/web-devicons as needed by remaining plugins.

## New modules

### `lua/config/completion.lua`

- On `LspAttach`: `vim.lsp.completion.enable(true, client.id, bufnr, opts)`
- Insert maps (preserve current muscle memory):
  - `<C-j>` / `<C-k>` — next/prev when `pumvisible()`
  - `<CR>` — confirm (`<C-y>`) when popup open
  - `<C-Space>` — `vim.lsp.completion.get()`
- Snippet jump: Tab / S-Tab → `vim.snippet.jump(±1)` when `vim.snippet.active()`
- Expand user snippets: `<C-l>` expands trigger word via `vim.snippet.expand`

### `lua/config/terminal.lua`

- `<C-t>` toggle floating terminal (reuse one buf/win)
- Horizontal runner for make targets and gotestsum watch (reuse one buf per role, like current toggleterm ids)
- Replace all `require("toggleterm...")` call sites in `keymaps.lua` and `autocmds.lua`

### `lua/config/ui.lua`

- Override `vim.ui.select` with a small float list (numbered lines + confirm), no Telescope dependency
- Telescope keeps find/grep/LSP pickers and remaining extensions (fzf only)

### Snippets

- Replace `lua/snippets/go.lua` LuaSnip API with a plain table of LSP-style snippet strings (`${1:placeholder}`)
- Cover existing triggers: `json`, `jsonomit`, `tt`, `trun`, `tc`, `ctx`, `rno`, `req`, `ano`, `aeq`
- Remove `lua/plugins/snippets.lua` (LuaSnip plugin spec)

## LSP changes

- Delete `lua/plugins/lspconfig.lua` (plugin + mason-lspconfig). Call `require("config.lsp").setup_servers()` from `init.lua` after `config.lazy`.
- Move `<leader>cf` format keymap into `config.lsp` or `keymaps.lua` (same behavior as today).
- Extend `lsp/gopls.lua` with `cmd`, `filetypes`, `root_markers` (previously inherited from nvim-lspconfig defaults).
- Ensure `lua_ls`, `jsonls`, `sqls`, `buf_ls` configs include enough `cmd` / `filetypes` / `root_markers` to start without lspconfig.
- Mason stays in `coding.lua` for `:Mason` / `:MasonInstall`; no automatic `ensure_installed` bridge.
- `on_attach` behavior stays as today.
- Capabilities: use `vim.lsp.protocol.make_client_capabilities()` (no `cmp_nvim_lsp`).

## Trouble keymap remaps

| Key | New behavior |
|-----|----------------|
| `<leader>xx` | `vim.diagnostic.setqflist()` + open quickfix |
| `<leader>xX` | buffer-filtered diagnostics → qflist + open |
| `<leader>xq` | toggle quickfix |
| `<leader>xl` | toggle loclist |
| `<leader>xs` | Telescope document/workspace symbols (existing Telescope) |
| `<leader>xr` | same as current `gr` references picker |

Remove trouble which-key group wording or retarget to “Lists”.

## File touch list

| Action | Path |
|--------|------|
| Add | `lua/config/completion.lua`, `terminal.lua`, `ui.lua` |
| Edit | `init.lua`, `lua/config/lsp.lua`, `lsp/gopls.lua`, `lua/config/keymaps.lua`, `lua/config/autocmds.lua` |
| Edit | `lua/plugins/coding.lua` (drop cmp; keep mason), `telescope.lua` (drop ui-select), `tasks.lua` (drop trouble) |
| Rewrite | `lua/snippets/go.lua` |
| Delete | `lua/plugins/toggleterm.lua`, `lua/plugins/snippets.lua`, `lua/plugins/lspconfig.lua` |
| Lock | `lazy-lock.json` updates after `:Lazy sync` |

## Out of scope

- Removing Telescope, lualine, yazi, gitsigns, lazygit.nvim, overseer
- Removing nvim-treesitter installer
- Mason → brew-only workflow
- LazyVim extras / README rebrand

## Success criteria

1. Neovim starts without missing-plugin errors for removed specs
2. LSP (gopls + configured servers) attaches; format/rename/code action work
3. Completion popup works with `<C-j>`/`<C-k>`/`<CR>`/`<C-Space>`
4. Go snippets expand via `<C-l>` and jump with Tab/S-Tab
5. `<C-t>` float terminal toggles; make and gotestsum watch run in horizontal terminal
6. `vim.ui.select` (e.g. code actions) works without telescope-ui-select
7. Former trouble keys open native lists / Telescope as specified
8. `:Mason` still opens; `:TSInstall` still available

## Risks

- Path completion from `cmp-path` is gone (LSP/path omnifunc only)
- Without mason-lspconfig, missing binaries need PATH or manual `:MasonInstall`
- Float `vim.ui.select` is simpler than Telescope dropdown
- Native LSP completion UX is thinner than nvim-cmp (no snippet items in the same menu unless LSP sends them)
