local MAKE_TERMINAL_DIRECTION = "horizontal"
local MAKE_TERMINAL_CLOSE_ON_EXIT = false
local MAKE_TERMINAL_ID = 80
local MAKE_TERMINAL_HEIGHT = 15

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

local function project_root()
  local filename = vim.api.nvim_buf_get_name(0)
  return vim.fs.root(filename, { "Makefile", "go.work", "go.mod", ".git" }) or vim.loop.cwd()
end

local function run_make(target)
  local Terminal = require("toggleterm.terminal").Terminal
  local command = target == "" and "make" or "make " .. target
  local terminal = Terminal:new({
    id = MAKE_TERMINAL_ID,
    cmd = command,
    dir = project_root(),
    direction = MAKE_TERMINAL_DIRECTION,
    close_on_exit = MAKE_TERMINAL_CLOSE_ON_EXIT,
    hidden = true,
    size = MAKE_TERMINAL_HEIGHT,
  })

  terminal:toggle()
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

map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
map("n", "<leader>dq", vim.diagnostic.setqflist, "Diagnostics to quickfix")
map("n", "]q", ":cnext<CR>", "Next quickfix item")
map("n", "[q", ":cprevious<CR>", "Previous quickfix item")
map("n", "<leader>qo", ":copen<CR>", "Open quickfix")
map("n", "<leader>qc", ":cclose<CR>", "Close quickfix")
map("t", "<Esc><Esc>", [[<C-\\><C-n>]], "Terminal normal mode")
map("t", "jk", [[<C-\\><C-n>]], "Terminal normal mode")

map("n", "<leader>mm", function()
  run_make("")
end, "Make")
map("n", "<leader>mt", function()
  run_make("test")
end, "Make test")
map("n", "<leader>ml", function()
  run_make("lint")
end, "Make lint")
map("n", "<leader>mb", function()
  run_make("build")
end, "Make build")
map("n", "<leader>mg", function()
  run_make("generate")
end, "Make generate")
