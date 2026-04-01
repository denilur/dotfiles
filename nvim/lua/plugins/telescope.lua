return {
  "nvim-telescope/telescope.nvim",
  lazy = true,
  tag = "0.1.8",
  -- or                              , branch = '0.1.x',
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope-file-browser.nvim",
  },
  keys = {
    {
      "gr",
      function()
        require("telescope.builtin").lsp_references({
          entry_maker = function(entry)
            local git_root = vim.fn.systemlist("git rev-parse --show-toplevel 2>/dev/null")[1]

            return {
              value = entry,
              ordinal = entry.filename,
              display = entry.filename:sub(#git_root + 2),
              filename = entry.filename,
              lnum = entry.lnum,
              col = entry.col,
            }
          end,
          -- Кастомное отображение путей
          path_display = { "relative" },
        })
      end,
      desc = "References (Telescope) with shortened paths",
    },
    { "gi", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto Implementation" },
    { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "[G]oto [D]efinition" },
    { "<leader>dd", "<cmd>Telescope diagnostics<cr>", desc = "Show diagnostics" },
  },
  config = function()
    local actions = require("telescope.actions")

    require("telescope").setup({
      extensions = {
        file_browser = {
          hijack_netrw = true,
        },
      },
      defaults = {
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
          vertical = {
            preview_height = 0.4,
            preview_cutoff = 40,
            height = 0.9,
            width = 0.8,
            prompt_position = "top",
            mirror = false,
          },
        },
        mappings = {
          i = {
            ["<esc>"] = actions.close,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-h>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
          },
          n = {},
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git", "--exclude", ".gitignore" },
        },
        live_grep = {
          additional_args = { "--hidden", "--glob=!.git" },
        },
        oldfiles = {
          hidden = true,
        },
      },
    })
    require("telescope").load_extension("file_browser")
  end,
}

