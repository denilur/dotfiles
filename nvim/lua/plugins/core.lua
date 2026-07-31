return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_c = { "filename" },
          lualine_x = { "location" },
        },
      })
    end,
  },
  { "tpope/vim-surround", event = { "BufReadPost", "BufNewFile" } },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    keys = {
      {
        "<leader>s",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Strings",
      },
      {
        "<leader>d",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>f",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Find",
      },
      {
        "<leader>g",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Git",
      },
      {
        "<leader>c",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Code",
      },
      {
        "<leader>r",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "gRPC",
      },
      {
        "<leader>t",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Tests",
      },
      {
        "<leader>q",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Quickfix",
      },
      {
        "<leader>x",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Trouble",
      },
      {
        "<localleader>g",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Go",
      },
    },
    opts = {
      preset = "helix",
      spec = {
        { "<BS>", desc = "Decrement Selection", mode = "x" },
        { "<c-space>", desc = "Increment Selection", mode = { "x", "n" } },
      },
    },
  },
}
