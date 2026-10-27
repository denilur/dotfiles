vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("config.options")
require("config.pack")
require("config.keymaps")
require("config.ui")
require("config.lsp").setup()
require("config.completion").setup()
require("config.format").setup()
require("config.go").setup_commands()

-- Plugin settings live in after/plugin/*.lua, filetype settings in after/ftplugin/*.lua.
