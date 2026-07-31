return {
  {
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerBuild",
      "OverseerRun",
      "OverseerToggle",
      "OverseerQuickAction",
    },
    keys = {
      { "<leader>rr", "<cmd>OverseerRun<cr>", desc = "Run task" },
      { "<leader>rt", "<cmd>OverseerToggle<cr>", desc = "Toggle tasks" },
      { "<leader>ra", "<cmd>OverseerQuickAction<cr>", desc = "Task action" },
    },
    opts = {
      templates = { "builtin" },
      task_list = {
        direction = "bottom",
        min_height = 12,
        max_height = 20,
        default_detail = 1,
      },
      form = {
        border = "rounded",
      },
      confirm = {
        border = "rounded",
      },
      task_win = {
        border = "rounded",
      },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols" },
      { "<leader>xr", "<cmd>Trouble lsp_references toggle<cr>", desc = "LSP references" },
    },
    opts = {
      focus = true,
      auto_close = false,
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>r", group = "Run" },
        { "<leader>x", group = "Trouble" },
      },
    },
  },
}
