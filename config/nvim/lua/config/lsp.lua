local M = {}

M.servers = { "gopls", "buf_ls", "lua_ls", "jsonls", "sqls" }

local function on_attach(client, bufnr)
  -- Highlighting comes from treesitter only.
  client.server_capabilities.semanticTokensProvider = nil

  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  -- Neovim defaults stay: K, grn (rename), gra (code action), grt, gO, <C-s> in insert.
  map({ "n", "x" }, "<leader>a", vim.lsp.buf.code_action, "Code action")
  map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
  map("n", "<C-s>", vim.lsp.buf.signature_help, "Signature help")
  map("n", "grD", vim.lsp.buf.declaration, "Goto declaration")

  local fzf = require("fzf-lua")
  map("n", "gd", fzf.lsp_definitions, "Goto definition")
  map("n", "grr", fzf.lsp_references, "LSP references")
  map("n", "gri", fzf.lsp_implementations, "Goto implementation")

  if client:supports_method("textDocument/typeHierarchy") then
    map("n", "grs", function()
      vim.lsp.buf.typehierarchy("subtypes")
    end, "Goto subtypes")
    map("n", "grS", function()
      vim.lsp.buf.typehierarchy("supertypes")
    end, "Goto supertypes")
  end

  if client:supports_method("textDocument/inlayHint") then
    map("n", "<leader>uh", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
    end, "Toggle inlay hints")
  end

  require("config.completion").on_attach(client, bufnr)
end

function M.setup()
  vim.lsp.config("buf_ls", {
    cmd = { "buf", "beta", "lsp", "--timeout", "0s" },
    filetypes = { "proto" },
    root_markers = { "buf.yaml", "buf.yml", ".git" },
  })

  vim.lsp.config("sqls", {
    cmd = { "sqls" },
    filetypes = { "sql", "mysql" },
    root_markers = { ".git" },
    settings = {
      sqls = {
        connections = {},
      },
    },
  })

  vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
      ".luarc.json",
      ".luarc.jsonc",
      ".stylua.toml",
      "stylua.toml",
      ".git",
    },
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        telemetry = { enable = false },
      },
    },
  })

  vim.lsp.config("jsonls", {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    root_markers = { ".git" },
    init_options = { provideFormatter = true },
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("dotfiles_lsp", { clear = true }),
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if client then
        on_attach(client, ev.buf)
      end
    end,
  })

  -- vim.lsp.enable starts each server lazily on its filetypes.
  vim.lsp.enable(M.servers)
end

return M
