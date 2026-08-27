local M = {}

M.servers_by_ft = {
  proto = "buf_ls",
  lua = "lua_ls",
  json = "jsonls",
  sql = "sqls",
  mysql = "sqls",
  plsql = "sqls",
  postgres = "sqls",
}

local enabled = {}

function M.capabilities()
  local caps
  local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    caps = cmp_lsp.default_capabilities()
  else
    caps = vim.lsp.protocol.make_client_capabilities()
    caps.textDocument.completion.completionItem.snippetSupport = true
  end
  caps.semanticTokensProvider = nil
  return caps
end


function M.on_attach(client, bufnr)
  if client.name == "gopls" then
    client.server_capabilities.semanticTokensProvider = nil
    vim.lsp.semantic_tokens.enable(false, { bufnr = bufnr })
    if vim.lsp.inlay_hint then
      vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
    end
  end

  local opts = { buffer = bufnr, silent = true }

  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))
  vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
  vim.keymap.set(
    "n",
    "grD",
    vim.lsp.buf.declaration,
    vim.tbl_extend("force", opts, { desc = "Goto declaration" })
  )

  if client:supports_method("textDocument/typeHierarchy") then
    vim.keymap.set("n", "grs", function()
      vim.lsp.buf.typehierarchy("subtypes")
    end, vim.tbl_extend("force", opts, { desc = "Goto subtypes" }))
    vim.keymap.set("n", "grS", function()
      vim.lsp.buf.typehierarchy("supertypes")
    end, vim.tbl_extend("force", opts, { desc = "Goto supertypes" }))
  end

  if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
    vim.keymap.set("n", "<leader>uh", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
    end, vim.tbl_extend("force", opts, { desc = "Toggle inlay hints" }))
  end
end

function M.enable_for_filetype(ft)
  local server = M.servers_by_ft[ft]
  if not server or enabled[server] then
    return
  end
  enabled[server] = true
  vim.lsp.enable(server)
end

function M.setup_servers()
  vim.lsp.config("*", {
    capabilities = M.capabilities(),
    on_attach = M.on_attach,
  })

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

  vim.lsp.enable("gopls")

  local group = vim.api.nvim_create_augroup("dotfiles_lsp_ft", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(ev)
      M.enable_for_filetype(vim.bo[ev.buf].filetype)
    end,
  })

  if vim.bo.filetype ~= "" then
    M.enable_for_filetype(vim.bo.filetype)
  end
end

return M
