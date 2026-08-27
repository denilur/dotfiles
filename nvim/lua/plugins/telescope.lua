local ROOT_MARKERS = { "go.work", "go.mod", "Makefile", ".git" }

local function project_root()
  local filename = vim.api.nvim_buf_get_name(0)
  return vim.fs.root(filename, ROOT_MARKERS) or vim.loop.cwd()
end

local function lsp_references()
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
end

return {
  "nvim-telescope/telescope.nvim",
  lazy = true,
  version = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  keys = {
    {
      "<leader>/",
      function()
        require("telescope.builtin").live_grep({ cwd = project_root() })
      end,
      desc = "Live grep",
    },
    {
      "<leader>ff",
      function()
        require("telescope.builtin").find_files({ cwd = project_root() })
      end,
      desc = "Find files",
    },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
    { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto definition" },
    { "gi", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto implementation" },
    { "gr", lsp_references, desc = "LSP references" },
    { "<leader>s", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
    { "<leader>dd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
  },
  config = function()
    local actions = require("telescope.actions")
    local telescope = require("telescope")

    telescope.setup({
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

    pcall(telescope.load_extension, "fzf")
  end,
}
