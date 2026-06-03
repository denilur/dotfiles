local function map(mode, lhs, rhs, desc_or_opts)
  local opts = {}
  if type(desc_or_opts) == "string" then
    opts = { desc = desc_or_opts }
  elseif type(desc_or_opts) == "table" then
    opts = desc_or_opts
  end
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.keymap.set("i", "jk", "<esc>")

vim.keymap.set({ "n", "x" }, "<leader>a", vim.lsp.buf.code_action, { desc = "Code action" })

vim.keymap.set({ "n", "i", "t" }, "<C-t>", function()
  require("toggleterm").toggle()
end, { desc = "Toggle terminal" })

vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })

map("n", "<Esc>", ":noh<CR>", "Clear highlight")

map("n", "]b", ":bnext<CR>", "Next buffer")
map("n", "[b", ":bprevious<CR>", "Previous buffer")
