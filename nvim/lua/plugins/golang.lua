return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<localleader>g", group = "Go" },
        { "<localleader>ga", desc = "Alternate test/source file" },
        { "<localleader>gi", desc = "Organize imports" },
        { "<localleader>gt", desc = "Run go test (package)" },
      },
    },
  },
}
