require("which-key").setup({
  preset = "helix",
  spec = {
    { "<leader>c", group = "Code" },
    { "<leader>d", group = "Debug / diagnostics" },
    { "<leader>f", group = "Find" },
    { "<leader>g", group = "Git" },
    { "<leader>m", group = "Make" },
    { "<leader>q", group = "Quickfix" },
    { "<leader>r", group = "gRPC" },
    { "<leader>t", group = "Tests" },
    { "<leader>u", group = "Toggle" },
    { "<leader>y", group = "Yank path", mode = { "n", "x" } },
    { "<localleader>e", group = "Extract", mode = { "x", "s" } },
    { "<localleader>g", group = "Go" },
    { "<BS>", desc = "Decrement Selection", mode = "x" },
    { "<c-space>", desc = "Increment Selection", mode = { "x", "n" } },
  },
})
