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

vim.keymap.set("n", "<leader>/", function()
    require("telescope.builtin").live_grep({
        cwd = require("lspconfig").util.root_pattern(".git", ".git/")(vim.fn.expand("%:p")) 
              or vim.loop.cwd(),
    })
end, { desc = "Find in files (project root)" })

vim.keymap.set("n", "<leader>fg", function()
    require("telescope.builtin").live_grep({
        cwd = require("lspconfig").util.root_pattern(".git", ".git/")(vim.fn.expand("%:p")) 
              or vim.loop.cwd(),
    })
end, { desc = "Find in files (project root)" })

vim.keymap.set("n", "<leader>ff", function()
    require("telescope.builtin").find_files({
        cwd = require("lspconfig").util.root_pattern(".git", ".git/")(vim.fn.expand("%:p")) 
              or vim.loop.cwd(),
    })
end, { desc = "Find files (project root)" })

vim.keymap.set("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", {desc="Find in buffers"})

    vim.keymap.set(
        { 'n', 'x' },
        '<leader>a',
        '<cmd>lua require("fastaction").code_action()<CR>',
        { desc = "Display code actions", buffer = bufnr }
    )

vim.api.nvim_set_keymap("n", "<C-t>", "<cmd>lua require('toggleterm').toggle()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-t>", "<cmd>lua require('toggleterm').toggle()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<C-t>", "<cmd>lua require('toggleterm').toggle()<CR>", { noremap = true, silent = true })

vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "signature of function" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer = bufnr,noremap = true, silent = true})

map("n", "<Esc>", ":noh<CR>", "Clear Highlight")

map("n", "]b", ":bnext<CR>", "Next Buffer")
map("n", "[b", ":bprevious<CR>", "Previous Buffer")

