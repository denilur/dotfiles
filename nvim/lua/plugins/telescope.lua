local function project_root()
  local ok, util = pcall(require, "lspconfig.util")
  if ok then
    return util.root_pattern(".git")(vim.fn.expand("%:p")) or vim.loop.cwd()
  end
  return vim.loop.cwd()
end

return {
  "nvim-telescope/telescope.nvim",
  lazy = true,
  version = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    {
      "<leader>/",
      function()
        require("telescope.builtin").live_grep({ cwd = project_root() })
      end,
      desc = "Live grep (project root)",
    },
    {
      "<leader>ff",
      function()
        require("telescope.builtin").find_files({ cwd = project_root() })
      end,
      desc = "Find files",
    },
    {
      "<leader>fg",
      function()
        require("telescope.builtin").live_grep({ cwd = project_root() })
      end,
      desc = "Live grep",
    },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
    { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto definition" },
    { "gi", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto implementation" },
    {
      "gr",
      function()
        require("telescope.builtin").lsp_references({
          entry_maker = function(entry)
            local git_root = vim.fn.systemlist("git rev-parse --show-toplevel 2>/dev/null")[1]
            return {
              value = entry,
              ordinal = entry.filename,
              display = git_root ~= "" and entry.filename:sub(#git_root + 2) or entry.filename,
              filename = entry.filename,
              lnum = entry.lnum,
              col = entry.col,
            }
          end,
          path_display = { "relative" },
        })
      end,
      desc = "LSP references",
    },
    { "<leader>dd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
  },
  config = function()
    local actions = require("telescope.actions")

    require("telescope").setup({
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
      },
    })
  end,
}
