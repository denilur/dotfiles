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
  s("tt", {
    t({ "func Test" }),
    i(1, "Name"),
    t({ "(t *testing.T) {", "\ttests := []struct {", "\t\tname string", "\t}{", "\t\t{", "\t\t\tname: \"" }),
    i(2, "success"),
    t({ "\",", "\t\t},", "\t}", "", "\tfor _, tt := range tests {", "\t\tt.Run(tt.name, func(t *testing.T) {", "\t\t\t" }),
    i(0),
    t({ "", "\t\t})", "\t}", "}" }),
  }, { description = "Table-driven test" }),
  s("trun", {
    t('t.Run("'),
    i(1, "name"),
    t({ '", func(t *testing.T) {', "\t" }),
    i(0),
    t({ "", "})" }),
  }, { description = "Subtest" }),
  s("tc", {
    t("func Test"),
    i(1, "Subject_Success"),
    t({ "(t *testing.T) {", "\ttestutils.RunCase(t, " }),
    i(2, "withDep"),
    t(", func(s *testutils.TestSuite, d "),
    i(3, "dep"),
    t(", h *"),
    i(4, "Handler"),
    t({ ") {", "\t\t" }),
    i(0),
    t({ "", "\t})", "}" }),
  }, { description = "Single testutils.RunCase test" }),
  s("ctx", {
    t("ctx := context.Background()"),
  }, { description = "context.Background" }),
  s("rno", {
    t("require.NoError(t, "),
    i(1, "err"),
    t(")"),
  }, { description = "require.NoError" }),
  s("req", {
    t("require.Equal(t, "),
    i(1, "want"),
    t(", "),
    i(2, "got"),
    t(")"),
  }, { description = "require.Equal" }),
  s("ano", {
    t("assert.NoError(t, "),
    i(1, "err"),
    t(")"),
  }, { description = "assert.NoError" }),
  s("aeq", {
    t("assert.Equal(t, "),
    i(1, "want"),
    t(", "),
    i(2, "got"),
    t(")"),
  }, { description = "assert.Equal" }),
}
