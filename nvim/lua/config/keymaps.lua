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


map("n", "<localleader>gn", ":GoTestFunc<CR>", "Run test func")

vim.keymap.set("i", "jk", "<esc>")

vim.keymap.set("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", {desc="Find files"})
vim.keymap.set("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", {desc="Find in files"})
vim.keymap.set("n", "<leader>/", "<cmd>lua require('telescope.builtin').live_grep()<cr>", {desc="Find in files"})
vim.keymap.set("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", {desc="Find in buffers"})

vim.api.nvim_set_keymap("n", "<C-t>", "<cmd>lua require('toggleterm').toggle()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-t>", "<cmd>lua require('toggleterm').toggle()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<C-t>", "<cmd>lua require('toggleterm').toggle()<CR>", { noremap = true, silent = true })

vim.api.nvim_create_user_command('GoFieldAlign', function()
  local filename = vim.fn.expand('%:p')
  if vim.bo.modified then
    vim.cmd('w')
  end
  local output = vim.fn.system('fieldalignment -fix ' .. vim.fn.shellescape(filename))
  if vim.v.shell_error == 0 then
    vim.cmd('e!')
    vim.notify('Файл выровнен успешно!', vim.log.levels.INFO)
  else
    vim.notify('Ошибка: ' .. output, vim.log.levels.ERROR)
  end
end, {})

vim.keymap.set("v", "<leader>ce", function()
    local prompt = vim.fn.input "Write a prompt: "
    return ":AIChatCodeEdit " .. prompt .. "<CR>"
end, {
    expr = true,
    desc = "Edit code via AIChat",
})

map("n", "<leader>w", ":w<CR>", "Save file")
map("n", "<Esc>", ":noh<CR>", "Clear Highlight")

map("n", "]b", ":bnext<CR>", "Next Buffer")
map("n", "[b", ":bprevious<CR>", "Previous Buffer")
