return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  -- or                              , branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    'nvim-tree/nvim-web-devicons',
    "nvim-telescope/telescope-file-browser.nvim",
  },
  keys = {
    { "gr", "<cmd>Telescope lsp_references<cr>",       desc = "References (Telescope)" },
    { "<leader>e", function()
        require("telescope").extensions.file_browser.file_browser({
            path = vim.fn.expand("%:p:h"),
        })
    end, desc = "File Browser (current dir)" },

    { "gi", "<cmd>Telescope lsp_implementations<cr>",  desc = "Goto Implementation" },
  },
  config = function()
    local actions = require("telescope.actions")

    require("telescope").setup {
      extensions = {
        file_browser = {
          hijack_netrw = true,
        }
      },
      defaults = {
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
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
    require("telescope").load_extension("file_browser")
  end
}
