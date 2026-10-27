local go = require("config.go")
local buf = vim.api.nvim_get_current_buf()

vim.opt_local.expandtab = false

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, desc = desc })
end

-- Tests
map("n", "<leader>tt", function()
  go.test_package(buf)
end, "Test package")
map("n", "<leader>tT", function()
  go.test_all(buf)
end, "Test all packages")
map("n", "<leader>tf", function()
  go.test_file(buf)
end, "Test file")
map("n", "<leader>tn", function()
  go.test_func(buf)
end, "Test function")
map("n", "<leader>tw", function()
  go.test_watch(buf)
end, "Watch package tests")
map("n", "<leader>tW", function()
  go.test_watch(buf, "./...")
end, "Watch all tests")
map("n", "<leader>td", function()
  go.debug_test()
end, "Debug test at cursor")

-- Files, imports, lint
map("n", "<localleader>ga", function()
  go.open_alternate(buf, "edit")
end, "Go alternate file")
map("n", "<localleader>gA", function()
  go.open_alternate(buf, "vsplit")
end, "Go alternate file in split")
map("n", "<localleader>gi", function()
  require("config.format").organize_imports(buf)
end, "Organize imports")
map("n", "<localleader>gl", function()
  go.lint_terminal(buf)
end, "Run golangci-lint")
map("n", "<localleader>gq", function()
  go.lint_quickfix(buf)
end, "golangci-lint to quickfix")

-- gopls code actions
local actions = {
  { "n", "<localleader>jl", "refactor.rewrite.joinLines", true, "Join lines" },
  { "n", "<localleader>sl", "refactor.rewrite.splitLines", true, "Split lines" },
  { "n", "<localleader>at", "source.addTest", true, "Add test" },
  { "n", "<localleader>fs", "refactor.rewrite.fillStruct", false, "Fill struct (choose)" },
  { "n", "<localleader>fS", "refactor.rewrite.fillStruct", true, "Fill struct" },
  { { "v", "s" }, "<localleader>em", "refactor.extract.method", true, "Extract method" },
  { { "v", "s" }, "<localleader>ef", "refactor.extract.function", true, "Extract function" },
  { { "v", "s" }, "<localleader>ec", "refactor.extract.constant", true, "Extract constant" },
  { { "v", "s" }, "<localleader>eC", "refactor.extract.constant-all", true, "Extract constant (all)" },
  { { "v", "s" }, "<localleader>ev", "refactor.extract.variable", true, "Extract variable" },
  { { "v", "s" }, "<localleader>eV", "refactor.extract.variable-all", true, "Extract variable (all)" },
}
for _, a in ipairs(actions) do
  map(a[1], a[2], function()
    go.code_action_by_kind(a[3], a[4])
  end, a[5])
end

map("n", "<localleader>fm", function()
  require("fzf-lua").live_grep({ cwd = vim.fs.joinpath(vim.env.GOPATH or (vim.env.HOME .. "/go"), "pkg/mod") })
end, "Grep in Go module cache")

-- Mechanical rewrites for mockery / testify migrations (confirm each match).
local rewrites = {
  GoReplaceDotComments = {
    [[%s/\/\/ \w* \.*$//gc]],
    "Remove comments that only repeat the declaration name",
  },
  GoReplaceMockeryRawMockWithNew = {
    [[%s/&mocks\.\(\w*\){}/mocks.New\1(t)/gc]],
    "&mocks.Foo{} -> mocks.NewFoo(t)",
  },
  GoReplaceMockeryOnWithExpect = {
    [[%s/On(\_.\{-}"\(\w*\)",/EXPECT().\1(/gc]],
    'mock.On("Method", ...) -> mock.EXPECT().Method(...)',
  },
  GoReplaceRequireWithSuiteRequire = {
    [[%s/require\.\(\w*\)(\(\w*\).T(), /\2.Require().\1(/gc]],
    "require.X(s.T(), ...) -> s.Require().X(...)",
  },
  GoReplaceAssertWithSuiteAssert = {
    [[%s/assert\.\(\w*\)(\(\w*\).T(), /\2.\1(/gc]],
    "assert.X(s.T(), ...) -> s.X(...)",
  },
}
for name, r in pairs(rewrites) do
  vim.api.nvim_buf_create_user_command(buf, name, r[1], { desc = r[2] })
end
