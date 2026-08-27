return {
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
    lazy = false,
    cmd = "Mason",
    build = ":MasonUpdate",
    dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim" },
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      require("mason-tool-installer").setup({
        ensure_installed = {
          "buf",
          "goimports",
          "golangci-lint",
          "gofumpt",
          "gopls",
          "gotestsum",
          "json-lsp",
          "jsonlint",
          "lua-language-server",
          "sqlfluff",
          "sqls",
          "stylua",
        },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-j>"] = cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Insert,
          }),
          ["<C-k>"] = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Insert,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }),
      })
    end,
  },
}

