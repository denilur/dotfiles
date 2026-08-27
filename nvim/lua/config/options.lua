local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if vim.uv.fs_stat(mason_bin) then
  vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

local opt = vim.opt

opt.confirm = true
opt.cursorline = true
opt.hlsearch = true
opt.smarttab = true
opt.smartindent = true
opt.expandtab = true
opt.number = true
opt.relativenumber = true

opt.autowrite = true
opt.autowriteall = true
opt.autoread = true

opt.showbreak = "↪"
opt.breakindent = true
opt.copyindent = true

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2

opt.completeopt = { "menu", "menuone", "noselect" }
opt.fillchars = { eob = " ", lastline = " ", fold = " " }

opt.ignorecase = true
opt.smartcase = true

opt.termguicolors = true
opt.mouse = "a"
opt.wrap = false
opt.showmode = true

opt.undofile = true
opt.swapfile = false
opt.fileencoding = "utf-8"

opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"

vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

opt.timeoutlen = 300
opt.updatetime = 250

opt.signcolumn = "yes"

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

opt.list = true
opt.listchars = {
  tab = ". ",
  trail = "·",
  nbsp = "␣",
}

opt.foldmethod = "indent"
opt.foldlevel = 99
opt.foldlevelstart = 99

vim.o.winborder = "rounded"
