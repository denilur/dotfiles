local mode = require("consts").modes

local function map(mode, mapping, cmd, options)
  local opts = { noremap = true }
  if options then
    opts = vim.tbl_extend("force", opts, options)
  end

  vim.api.nvim_set_keymap(mode, mapping, cmd, opts)
end

vim.g.mapleader = " "

-- Pane navigation
map(mode.normal, "<C-j>", "<C-w><C-j>")
map(mode.normal, "<C-k>", "<C-w><C-k>")
map(mode.normal, "<C-l>", "<C-w><C-l>")
map(mode.normal, "<C-h>", "<C-w><C-h>")

-- Equalize pane widths
map(mode.normal, "<leader>=", "<C-W><C-=>")

-- Nvim-tree
map(mode.normal, "<leader>e", ":Neotree<CR>")

-- Telescope
map(mode.normal, "<leader>p", ":Telescope find_files hidden=true<CR>")
map(mode.normal, "<leader>f", ":Telescope live_grep<CR>")
map(mode.normal, "<leader>s", ":Telescope grep_string<CR>")
map(mode.normal, "<leader>b", ":Telescope buffers<CR>")
map(mode.normal, "<leader>h", ":Telescope help_tags<CR>")

-- Terminal buffer-scoped maps
function _G.set_terminal_keymaps()
  local opts = { noremap = true }
  vim.api.nvim_buf_set_keymap(0, mode.terminal, "<esc>", [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, mode.terminal, "<C-j>", [[<C-\><C-n><C-j>]], opts)
  vim.api.nvim_buf_set_keymap(0, mode.terminal, "<C-k>", [[<C-\><C-n><C-w>k]], opts)
  vim.api.nvim_buf_set_keymap(0, mode.terminal, "<C-l>", [[<C-\><C-n><C-l>]], opts)
  vim.api.nvim_buf_set_keymap(0, mode.terminal, "<C-h>", [[<C-\><C-n><C-h>]], opts)
end

vim.cmd [[ autocmd TermOpen term://* lua set_terminal_keymaps() ]]

-- buffer
vim.cmd [[ nnoremap <Tab> : bnext!<CR> ]]
vim.cmd [[ nnoremap <S-Tab> : bprevious!<CR> ]]
map(mode.normal, "<leader>d", ":bdelete<CR>")
