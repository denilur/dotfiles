return {
  "L3MON4D3/LuaSnip",
  lazy = true,
  config = function()
    require("luasnip").config.set_config({ history = true, updateevents = "TextChanged,InsertEnter" })
    require("luasnip.loaders.from_lua").lazy_load({
      paths = vim.fn.stdpath("config") .. "/lua/snippets",
    })
  end,
}
