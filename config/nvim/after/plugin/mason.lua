-- Mason installs binaries only; servers are enabled in lua/config/lsp.lua.
require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

require("mason-tool-installer").setup({
  ensure_installed = {
    "buf",
    "delve",
    "golangci-lint",
    "gopls",
    "gotestsum",
    "json-lsp",
    "jsonlint",
    "lua-language-server",
    "sqlfluff",
    "sqls",
    "stylua",
  },
  run_on_start = not vim.tbl_contains(vim.v.argv, "--headless"),
})
