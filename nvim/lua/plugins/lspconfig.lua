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

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            gofumpt = true,
            codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-node_modules" },
              semanticTokens = true,
            },
        },
      })

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
      vim.lsp.enable("gopls")
      vim.lsp.enable("sqls")
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("jsonls")
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

