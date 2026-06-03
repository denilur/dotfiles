local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

return {
  s("json", {
    t('`json:"'),
    i(1, "field_name"),
    t('"'),
    t("`"),
  }, { description = "JSON struct tag" }),
  s("jsonomit", {
    t('`json:"'),
    i(1, "field_name"),
    t(',omitempty"'),
    t("`"),
  }, { description = "JSON struct tag with omitempty" }),
}
