-- Native LSP completion (vim.lsp.completion) + snippets (vim.snippet).
-- Paths: <C-x><C-f>. Buffer words: <C-n>.
local M = {}

local function pumvisible()
  return vim.fn.pumvisible() == 1
end

local function nothing_selected()
  return vim.fn.complete_info({ "selected" }).selected == -1
end

function M.on_attach(client, bufnr)
  if client:supports_method("textDocument/completion") then
    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
  end
end

function M.setup()
  local function map(modes, lhs, rhs, desc)
    vim.keymap.set(modes, lhs, rhs, { expr = true, silent = true, desc = desc })
  end

  map("i", "<C-j>", function()
    return pumvisible() and "<C-n>" or "<C-j>"
  end, "Next completion item")

  map("i", "<C-k>", function()
    return pumvisible() and "<C-p>" or "<C-k>"
  end, "Previous completion item")

  -- Confirm the selected item, or the first one when nothing is selected.
  map("i", "<CR>", function()
    if not pumvisible() then
      return "<CR>"
    end
    return nothing_selected() and "<C-n><C-y>" or "<C-y>"
  end, "Confirm completion")

  map({ "i", "s" }, "<Tab>", function()
    if pumvisible() then
      return "<C-n>"
    end
    if vim.snippet.active({ direction = 1 }) then
      return "<Cmd>lua vim.snippet.jump(1)<CR>"
    end
    return "<Tab>"
  end, "Next item / snippet field")

  map({ "i", "s" }, "<S-Tab>", function()
    if pumvisible() then
      return "<C-p>"
    end
    if vim.snippet.active({ direction = -1 }) then
      return "<Cmd>lua vim.snippet.jump(-1)<CR>"
    end
    return "<S-Tab>"
  end, "Previous item / snippet field")

  vim.keymap.set("i", "<C-Space>", vim.lsp.completion.get, { desc = "Trigger completion" })
end

return M
