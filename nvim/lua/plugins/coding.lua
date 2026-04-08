return {
  {
    "vinnymeller/swagger-preview.nvim",
    cmd = { "SwaggerPreview", "SwaggerPreviewStop", "SwaggerPreviewToggle" },
    build = "npm i",
    config = true,
  },

  {
    "Chaitanyabsprip/fastaction.nvim",
    opts = {},
  },
  {
    "stevearc/aerial.nvim",
    keys = {
      { "<localleader>a", "<cmd>AerialNavToggle<cr>", desc = "list code symbols" },
    },
    opts = {},
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "mikavilpas/yazi.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
      { "//", "<cmd>Yazi<cr>", desc = "Open yazi at current file" },
      { "<localleader>e", "<cmd>Yazi cwd<cr>", desc = "Open yazi at cwd" },
    },
    opts = {
      open_for_directories = true,
      enable_mouse_support = true,
      floating_window_scaling_factor = 0.9,
      yazi_floating_window_border = "rounded",
      show_hidden = true,
      focus_on_open = true,
      keymaps = {
        show_help = "<f1>",
        open_file_in_vertical_split = "<c-v>",
        open_file_in_horizontal_split = "<c-s>",
        close = "q",
      },
    },
    init = function()
      vim.g.loaded_netrwPlugin = 1
      vim.g.loaded_netrw = 1
    end,
  },
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
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({})
      vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>", { desc = "blame current line", noremap = true })
      vim.keymap.set("n", "<leader>gB", "<cmd>Gitsigns blame<CR>", { desc = "blame current file", noremap = true })
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
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = true,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "go", "gomod", "gowork" },
        highlight = { enable = true },
      })
    end,
  },
  { "tpope/vim-dadbod", lazy = true },
  {
    "kristijanhusak/vim-dadbod-ui",
    lazy = true,
    cmd = { "DB", "DBUI" },
    ft = { "sql", "mysql", "plsql" },
    config = function()
      vim.g.db_ui_save_location = vim.fn.getcwd() .. "/sql/"
    end,
    dependencies = {
      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-completion",
    },
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    lazy = true,
    config = function()
      vim.cmd([[
                autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni
            ]])
    end,
  },
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig", -- только для legacy, если что‑то ещё использует
      "hrsh7th/nvim-cmp",
    },
    ft = { "go", "gomod" },
    config = function()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      -- Capabilities для nvim‑cmp
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Общий on_attach для всех LSP
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, silent = true }

        -- Основные LSP‑шорткаты
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                async = false,
                timeout_ms = 1000,
              })
            end,
          })
        end
      end

      -- Настройка go.nvim
      require("go").setup({
        goimport = "goimports", -- использовать goimports
        gofmt = "goimports", -- форматирование через goimports
        lsp_cfg = false,
        lsp_on_attach = false,
        tag_transform = false,

        golangci_lint = {
          config = vim.fn.expand("~/.config/.golangci.yml"),
          default = "standard",
          disable = {},
          no_config = false,
        },
      })

      -- Настройка gopls через vim.lsp.config
      vim.lsp.config("gopls", {
        capabilities = capabilities,
        on_attach = on_attach,

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
              recursiveiter = true,
              maprange = true,
              framepointer = true,
              nilness = true,
              hostport = true,
              gofix = true,
              sigchanyzer = true,
              unreachable = true,
              unusedfunc = true,
              unusedparams = true,
              unusedvariable = true,
              unusedwrite = true,
              useany = true,
            },
            staticcheck = true,
            gofumpt = false, -- форматирование делает go.nvim
            completeUnimported = true,
            usePlaceholders = false,
            semanticTokens = false,
            diagnosticsDelay = "250ms",
            annotations = {
              bounds = true,
              escape = true,
              inline = true,
            },
          },
        },
      })

      -- Включаем gopls (через новый API)
      vim.lsp.enable("gopls")
    end,
  },
}
