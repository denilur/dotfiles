local HORIZONTAL_TERMINAL_HEIGHT = 15
local VERTICAL_TERMINAL_WIDTH_FACTOR = 0.5
local FLOAT_TERMINAL_WIDTH_FACTOR = 0.9
local FLOAT_TERMINAL_HEIGHT_FACTOR = 0.85

return {
  "akinsho/toggleterm.nvim",
  lazy = true,
  config = function()
    require("toggleterm").setup({
      direction = "float",
      persist_size = true,
      start_in_insert = true,
      close_on_exit = false,
      shade_terminals = false,
      float_opts = {
        border = "rounded",
        width = math.floor(vim.o.columns * FLOAT_TERMINAL_WIDTH_FACTOR),
        height = math.floor(vim.o.lines * FLOAT_TERMINAL_HEIGHT_FACTOR),
      },
      size = function(term)
        if term.direction == "horizontal" then
          return HORIZONTAL_TERMINAL_HEIGHT
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * VERTICAL_TERMINAL_WIDTH_FACTOR)
        end
      end,
    })
  end,
}
