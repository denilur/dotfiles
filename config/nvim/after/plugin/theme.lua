-- ilyasyoy-mono (github.com/IlyasYOY/theme.nvim): one monochrome colorscheme,
-- dark/light palette is picked from 'background'.
-- Follows macOS Appearance via auto-dark-mode; override with NVIM_BACKGROUND=dark|light

local COLORSCHEME = "ilyasyoy-mono"
local AUTO_DARK_MODE_INTERVAL_MS = 3000

local fixed = vim.env.NVIM_BACKGROUND
if fixed == "dark" or fixed == "light" then
  vim.o.background = fixed
  vim.cmd.colorscheme(COLORSCHEME)
  return
end

vim.cmd.colorscheme(COLORSCHEME)

require("auto-dark-mode").setup({
  update_interval = AUTO_DARK_MODE_INTERVAL_MS,
  fallback = "dark",
  dark_mode_colorscheme = COLORSCHEME,
  light_mode_colorscheme = COLORSCHEME,
})
