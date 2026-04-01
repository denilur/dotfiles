local opt = vim.opt
opt.confirm = true
opt.cursorline = true
opt.hlsearch = true
opt.smarttab = true
opt.smartindent = true
opt.expandtab = true
opt.number = true
opt.relativenumber = true

opt.autowrite = true -- сохраняет файл при переключении буферов
opt.autowriteall = true
opt.autoread = true -- автоматически перечитывать файл, если изменен вне vim

opt.showbreak = '↪' --  показывает символ ↪ в начале перенесенных строк
opt.breakindent = true -- сохраняет отступ при переносе строки
opt.copyindent = true -- копирует структуру отступов с предыдущей строки

opt.tabstop = 2
opt.softtabstop = 2
opt.swapfile = false
opt.shiftwidth = 2
vim.opt.expandtab = true

opt.completeopt = {'menu', 'menuone', 'noselect'}
opt.fillchars = { eob = " " } -- Убрать символ ~ в конце буфера (визуальный мусор)

opt.ignorecase = true -- Игнорировать регистр при поиске
opt.smartcase = true -- Но учитывать, если в запросе есть заглавные буквы

opt.termguicolors = true -- Поддержка 24-bit цветов
opt.mouse = "a" -- Включить мышь во всех режимах
opt.wrap = false -- Автоматический перенос длинных строк
opt.showmode = false -- Отключает отображение текущего режима (-- INSERT --) внизу, так как он уже есть в статус-линии

opt.undofile = true -- Сохранять историю отмен между сессиями
opt.swapfile = false -- Отключить swap-файлы (они раздражают)
opt.fileencoding = "utf-8" -- Кодировка файлов

vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.splitkeep = 'screen'

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

opt.timeoutlen = 300 -- Время ожидания комбинаций клавиш (мс)
opt.updatetime = 250

opt.signcolumn = "yes"

vim.diagnostic.config({
  signs = true,
  update_in_insert = true,
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
  trail = '·',
  nbsp = '␣',
}

opt.fillchars = {
  eob = ' ',
  lastline = ' ',
  fold = ' ',
}

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 0
vim.opt.foldlevelstart = 99
vim.opt.foldtext = ''
vim.o.winborder = "rounded"
