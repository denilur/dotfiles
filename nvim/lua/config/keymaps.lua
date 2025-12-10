vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.keymap.set('n', '<esc>', ':nohlsearch<CR>', { noremap = true, silent = true })

vim.keymap.set("i", "jk", "<esc>")

vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<cr>", { silent = true, noremap = true })

vim.keymap.set("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", {desc="Find files"})
vim.keymap.set("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", {desc="Find in files"})
vim.keymap.set("n", "<leader>/", "<cmd>lua require('telescope.builtin').live_grep()<cr>", {desc="Find in files"})
vim.keymap.set("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", {desc="Find in buffers"})

vim.api.nvim_set_keymap("n", "<C-t>", "<cmd>lua require('toggleterm').toggle()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-t>", "<cmd>lua require('toggleterm').toggle()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<C-t>", "<cmd>lua require('toggleterm').toggle()<CR>", { noremap = true, silent = true })

-- Move highlighted blocks with J and K
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

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
