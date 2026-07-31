return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<localleader>g", group = "Go" },
        { "<localleader>ga", desc = "Alternate test/source file" },
        { "<localleader>gA", desc = "Alternate test/source file in split" },
        { "<localleader>gi", desc = "Organize imports" },
        { "<localleader>gt", desc = "Run go test (package)" },
        { "<localleader>gT", desc = "Run go test ./..." },
        { "<localleader>gw", desc = "Watch package tests" },
        { "<localleader>gW", desc = "Watch all tests" },
        { "<localleader>gl", desc = "Run golangci-lint" },
        { "<leader>t", group = "Tests" },
        { "<leader>tp", desc = "Go test package" },
        { "<leader>ta", desc = "Go test all packages" },
        { "<leader>tw", desc = "Watch package tests" },
        { "<leader>tW", desc = "Watch all tests" },
      },
    },
  },
}
