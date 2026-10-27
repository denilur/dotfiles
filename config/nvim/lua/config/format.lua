-- Format on save. Formatters work on the buffer contents, not the file on disk,
-- so unsaved changes are never lost or overwritten.
local M = {}

local GO_FORMAT_TIMEOUT_MS = 5000
local SQL_FORMAT_COMMAND = "sqlfluff"

-- Apply gopls "source.organizeImports" synchronously (goimports behaviour).
function M.organize_imports(bufnr)
  local client = vim.lsp.get_clients({ bufnr = bufnr, name = "gopls" })[1]
  if not client then
    return
  end

  local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
  params.context = { only = { "source.organizeImports" }, diagnostics = {} }

  local response = client:request_sync("textDocument/codeAction", params, GO_FORMAT_TIMEOUT_MS, bufnr)
  for _, action in ipairs(response and response.result or {}) do
    if action.edit then
      vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
    end
    if type(action.command) == "table" then
      client:exec_cmd(action.command, { bufnr = bufnr })
    end
  end
end

-- gopls formats with gofumpt (see lsp/gopls.lua).
local function format_go(bufnr)
  M.organize_imports(bufnr)
  vim.lsp.buf.format({
    bufnr = bufnr,
    async = false,
    timeout_ms = GO_FORMAT_TIMEOUT_MS,
    filter = function(client)
      return client.name == "gopls"
    end,
  })
end

-- Pipe the buffer through `sqlfluff format -`; run from the file's directory so
-- the project's .sqlfluff config is picked up.
local function format_sql(bufnr)
  if vim.fn.executable(SQL_FORMAT_COMMAND) == 0 then
    vim.notify("sqlfluff not found; skip SQL formatting", vim.log.levels.WARN)
    return
  end

  local filename = vim.api.nvim_buf_get_name(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local result = vim
    .system({ SQL_FORMAT_COMMAND, "format", "-" }, {
      cwd = vim.fs.dirname(filename),
      stdin = table.concat(lines, "\n") .. "\n",
      text = true,
    })
    :wait()

  -- Exit 1 means "formatted, but unfixable violations remain".
  if (result.code ~= 0 and result.code ~= 1) or not result.stdout or result.stdout == "" then
    vim.notify("sqlfluff: " .. (result.stderr or "failed"), vim.log.levels.WARN)
    return
  end

  local formatted = vim.split(result.stdout:gsub("\n$", ""), "\n", { plain = true })
  if vim.deep_equal(formatted, lines) then
    return
  end

  local view = vim.fn.winsaveview()
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted)
  vim.fn.winrestview(view)
end

local formatters = {
  go = format_go,
  sql = format_sql,
}

function M.setup()
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("dotfiles_format", { clear = true }),
    callback = function(ev)
      local formatter = formatters[vim.bo[ev.buf].filetype]
      if not formatter and ev.file:match("%.sqlm$") then
        formatter = format_sql
      end
      if formatter then
        formatter(ev.buf)
      end
    end,
  })
end

return M
