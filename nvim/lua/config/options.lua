local opt = vim.opt
opt.confirm = true
opt.cursorline = true
opt.hlsearch = true
opt.smarttab = true
opt.smartindent = true
opt.expandtab = true
opt.number = true
opt.relativenumber = true

opt.tabstop = 2
opt.softtabstop = 2
opt.swapfile = false
opt.shiftwidth = 2

opt.completeopt = {'menu', 'menuone', 'noselect'}
opt.fillchars = { eob = " " } -- Убрать символ ~ в конце буфера (визуальный мусор)

opt.ignorecase = true -- Игнорировать регистр при поиске
opt.smartcase = true -- Но учитывать, если в запросе есть заглавные буквы

opt.termguicolors = true -- Поддержка 24-bit цветов
opt.mouse = "a" -- Включить мышь во всех режимах
opt.wrap = false -- Автоматический перенос длинных строк

opt.undofile = true -- Сохранять историю отмен между сессиями
opt.swapfile = false -- Отключить swap-файлы (они раздражают)
opt.fileencoding = "utf-8" -- Кодировка файлов
opt.clipboard = "unnamedplus" -- Использовать системный буфер обмена

opt.timeoutlen = 400 -- Время ожидания комбинаций клавиш (мс)

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
