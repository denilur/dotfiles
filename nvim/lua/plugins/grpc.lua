return {
  {
    "hudclark/grpc-nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Grpc",
    keys = {
      {
        "<leader>rg",
        "<cmd>Grpc<cr>",
        desc = "Run gRPC request",
      },
    },
    config = function()
      if vim.fn.executable("grpcurl") == 0 then
        vim.notify("grpc-nvim: grpcurl not found (brew install grpcurl)", vim.log.levels.WARN)
      end
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>r", group = "gRPC" },
        { "<leader>rg", desc = "Run gRPC request" },
      },
    },
  },
}
