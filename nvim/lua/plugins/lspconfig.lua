return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("config.lsp").setup_servers()

      vim.keymap.set("n", "<leader>cf", function()
        vim.lsp.buf.format({ async = true })
      end, { desc = "Format buffer" })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    cmd = "Mason",
    opts = {
      ensure_installed = { "gopls", "buf_ls", "lua_ls", "jsonls", "sqls" },
      automatic_installation = true,
    },
  },
}
