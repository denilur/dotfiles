return {
  "L3MON4D3/LuaSnip",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  config = function(plugin, opts)
    require("luasnip").config.set_config(opts)
    require("luasnip.loaders.from_lua").lazy_load({
      paths = { "./lua/config/snippets.lua" }
    })
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_snipmate").lazy_load()
  end,
}
