return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  -- or                              , branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    { "gr", "<cmd>Telescope lsp_references<cr>",       desc = "References (Telescope)" },
    { "gR", "<cmd>Telescope lsp_references<cr>",       desc = "References (Telescope)" },

    { "gd", "<cmd>Telescope lsp_definitions<cr>",      desc = "Goto Definition" },
    { "gi", "<cmd>Telescope lsp_implementations<cr>",  desc = "Goto Implementation" },
    { "gt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto Type Definition" },
  },
  config = function()
    local actions = require("telescope.actions")

    require("telescope").setup {
      defaults = {
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            preview_width = 0.6,
            height = 0.8,
            width = 0.8,
            preview_cutoff = 120,
            prompt_position = "top",
          },
          vertical = {
            preview_height = 0.5,
            height = 0.9,
            width = 0.8,
            prompt_position = "top",
          }, },
        mappings = {
          i = {
            ["<esc>"] = actions.close,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-h>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
          },
          n = {

          }
        },
      }
    }
  end
}
