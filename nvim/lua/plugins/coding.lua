return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        automatic_installation = true,
      })
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({})
        end,
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-j>"] = cmp.mapping.select_next_item({
            behavior = cmp.ConfirmBehavior.Insert,
          }),
          ["<C-k>"] = cmp.mapping.select_prev_item({
            behavior = cmp.ConfirmBehavior.Insert,
          }),

        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
          { name = "luasnip" },
        }),
      })
    end,
  },
  "nvim-lua/plenary.nvim",
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
      init_options = {
    documentFormatting = true,
  },
    config = function()
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)

      -- Mappings.
      local opts = { buffer = bufnr, noremap = true, silent = true }
      -- Навигация
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

      vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, { desc = "Code action" })
      vim.keymap.set('n', '<leader>l', function() vim.lsp.buf.format({ async = true }) end, opts)

      -- Диагностика
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

      vim.keymap.set('n', '<leader>sl', function()
          vim.lsp.buf.code_action {
            apply = true,
            filter = function(x)
              return x.kind == "refactor.rewrite.splitLines"
            end,
          }
        end,
        { buffer = true }
      )

      vim.keymap.set("n", "<leader>oi", function()
        vim.lsp.buf.code_action {
          apply = true,
          filter = function(x)
            return x.kind == "source.organizeImports"
          end,
        }
      end, {
        buffer = true,
      }
      )

      vim.keymap.set("n", "<leader>fs", function()
        vim.lsp.buf.code_action {
          filter = function(x)
            return x.kind == "refactor.rewrite.fillStruct"
          end,
        }
      end, {
        buffer = true,
      })

      vim.keymap.set("n", "<leader>fS", function()
        vim.lsp.buf.code_action {
          apply = true,
          filter = function(x)
            return x.kind == "refactor.rewrite.fillStruct"
          end,
        }
      end, {
        buffer = true,
      })

      vim.keymap.set({ "v", "s" }, "<leader>em", function()
        vim.lsp.buf.code_action {
          apply = true,
          filter = function(x)
            return x.kind == "refactor.extract.method"
          end,
        }
      end, {
        buffer = true,
      })

      vim.keymap.set({ "v", "s" }, "<leader>ef", function()
        vim.lsp.buf.code_action {
          apply = true,
          filter = function(x)
            return x.kind == "refactor.extract.function"
          end,
        }
      end, {
        buffer = true,
      })

      vim.keymap.set({ "v", "s" }, "<leader>eC", function()
        vim.lsp.buf.code_action {
          apply = true,
          filter = function(x)
            return x.kind == "refactor.extract.constant-all"
          end,
        }
      end, {
        buffer = true,
      })

      vim.keymap.set({ "v", "s" }, "<leader>ec", function()
        vim.lsp.buf.code_action {
          apply = true,
          filter = function(x)
            return x.kind == "refactor.extract.constant"
          end,
        }
      end, {
        buffer = true,
      })

      vim.keymap.set({ "v", "s" }, "<leader>eV", function()
        vim.lsp.buf.code_action {
          apply = true,
          filter = function(x)
            return x.kind == "refactor.extract.variable-all"
          end,
        }
      end, {
        buffer = true,
      })

      vim.keymap.set({ "v", "s" }, "<leader>ev", function()
        vim.lsp.buf.code_action {
          apply = true,
          filter = function(x)
            return x.kind == "refactor.extract.variable"
          end,
        }
      end, {
        buffer = true,
      })

      -- Signature of function
      vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)

      vim.keymap.set('n', '<leader>ga', function()
        local current_file = vim.fn.expand('%')
        if current_file:match('_test%.go$') then
          vim.cmd('e ' .. current_file:gsub('_test%.go$', '.go'))
        else
          vim.cmd('e ' .. current_file:gsub('%.go$', '_test.go'))
        end
      end, opts)
    end
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup {}
      vim.keymap.set(
        "n",
        "<leader>gb",
        "<cmd>Gitsigns blame_line<CR>",
        { desc = "blame current line", noremap = true }
      )
      vim.keymap.set(
        "n",
        "<leader>gB",
        "<cmd>Gitsigns blame<CR>",
        { desc = "blame current file", noremap = true }
      )
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
  },
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "hrsh7th/nvim-cmp",
    },
    ft = { "go", "gomod" },
    config = function()
      require("go").setup({
        goimport = "goimports",
        gofmt = "gopls",
        lsp_cfg = false,   -- Важно: отключаем автоматическую настройку LSP
        lsp_on_attach = false,
        tag_transform = false,
      })

      -- Настройка LSP для Go
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      lspconfig.gopls.setup({
        capabilities = capabilities,
        settings = {
          gopls = {
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
              unusedparams = true,
              unusedwrite = true,
              shadow = true,
              nilness = true,
              unusedvariable = true,
              useany = true,
              defer = true,
              stringintconv = true,
              nilfunc = true,
              printf = true,
              structtag = true,
              testinggoroutine = true,
              unreachable = true,
              unsafeptr = true,
              unusedresult = true,
            },
            staticcheck = false,
            gofumpt = true,
            completeUnimported = true,
            usePlaceholders = false,
            semanticTokens = false,
            annotations = {
              bounds = true,
              escape = true,
              inline = true,
            },
          },
        },
        on_attach = function(client, bufnr)
          -- Форматирование при сохранении
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "go", "gomod", "gowork" },
        highlight = { enable = true },
      })
    end,
  },
  {
    "folke/trouble.nvim",
    opts = {
      modes = {
        lsp = {
          win = { position = "right" },
        },
      },
    },   -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>dd",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>dD",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
    },
  }
}
