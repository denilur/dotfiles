return {
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

    vim.api.nvim_create_user_command("Grpc", function()
      require("grpc.run").execute_under_cursor()
    end, { force = true })
  end,
}
