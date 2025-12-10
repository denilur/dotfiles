local opt = vim.opt
opt.confirm = true
opt.cursorline = true
opt.hlsearch = true
opt.expandtab = true
opt.number = true
opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.swapfile = false
vim.opt.shiftwidth = 2

vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

vim.diagnostic.config({
  signs = true,
  update_in_insert = false,
  underline = true,
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
})
