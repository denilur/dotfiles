return {
  {
    "neovim/nvim-lspconfig",
    opts = {},
    init_options = {
      documentFormatting = true
    },
    config = function(_, opts)
      vim.lsp.config("buf_ls", {
        cmd = { "buf", "beta", "lsp", "--timeout", "0s" },
        filetypes = { "proto" },
        settings = {},
      })

      vim.keymap.set('n', '<localleader>ga', function()
        local current_file = vim.fn.expand('%')
        if current_file:match('_test%.go$') then
          vim.cmd('e ' .. current_file:gsub('_test%.go$', '.go'))
        else
          vim.cmd('e ' .. current_file:gsub('%.go$', '_test.go'))
        end
      end, {desc = "go alternative file"})

      vim.lsp.config("sqls", {
        settings = {
          sqls = {
            connections = {
            },
          },
        },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config("jsonls", {})

      vim.lsp.enable("buf_ls")
      vim.lsp.enable("sqls")
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("jsonls")

      vim.keymap.set('n', '<leader>cf', function() vim.lsp.buf.format({ async = true }) end, {desc = "Format"})

      vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { desc = "signature of function"})
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "buf_ls", "gopls" , "jsonls" },
      automatic_enable = true, 
    },
  },
}

