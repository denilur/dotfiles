local M = {}

local GO_ROOT_MARKERS = { "go.work", "go.mod", ".git" }
local GOTESTSUM_FORMAT = "testname"
local TERMINAL_HEIGHT = 15

function M.current_root(bufnr)
  bufnr = bufnr or 0
  local filename = vim.api.nvim_buf_get_name(bufnr)
  return vim.fs.root(filename, GO_ROOT_MARKERS) or vim.uv.cwd()
end

local function relative_package(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local root = M.current_root(bufnr)
  local directory = vim.fs.dirname(filename)
  local relative = vim.fs.relpath(root, directory)

  if not relative or relative == "." then
    return "."
  end

  return "./" .. relative
end

local function run_in_terminal(command, bufnr, slot)
  require("config.terminal").run({
    cmd = command,
    cwd = M.current_root(bufnr),
    slot = slot or "go-test",
    height = TERMINAL_HEIGHT,
  })
end

local function go_test_cmd(package, extra_args, run_filter)
  local parts = { "go", "test", "-v", "-count=1" }

  if run_filter and run_filter ~= "" then
    table.insert(parts, "-run")
    table.insert(parts, run_filter)
  end

  if extra_args and extra_args ~= "" then
    for token in extra_args:gmatch("%S+") do
      table.insert(parts, token)
    end
  end

  table.insert(parts, package)
  return table.concat(parts, " ")
end

local function gotestsum_cmd(package, extra_args, run_filter)
  if vim.fn.executable("gotestsum") == 0 then
    return go_test_cmd(package, extra_args, run_filter)
  end

  local parts = { "gotestsum", "--format", GOTESTSUM_FORMAT, "--" }
  table.insert(parts, "go")
  table.insert(parts, "test")
  table.insert(parts, "-v")
  table.insert(parts, "-count=1")

  if run_filter and run_filter ~= "" then
    table.insert(parts, "-run")
    table.insert(parts, run_filter)
  end

  if extra_args and extra_args ~= "" then
    for token in extra_args:gmatch("%S+") do
      table.insert(parts, token)
    end
  end

  table.insert(parts, package)
  return table.concat(parts, " ")
end

local function function_name_at_cursor(bufnr)
  bufnr = bufnr or 0
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1

  local ok, node = pcall(vim.treesitter.get_node, {
    bufnr,
    row,
    col,
    row,
    col,
  })
  if not ok or not node then
    return nil
  end

  while node do
    local node_type = node:type()
    if node_type == "function_declaration" or node_type == "method_declaration" then
      local name_node = node:field("name")
      if name_node and name_node[1] then
        return vim.treesitter.get_node_text(name_node[1], bufnr)
      end
    end
    node = node:parent()
  end

  return nil
end

local function test_names_in_buffer(bufnr)
  bufnr = bufnr or 0
  local names = {}
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for _, line in ipairs(lines) do
    local name = line:match("^func%s+%((%w+)?%s*%w+%s+%*%w+%s+%)(%w+)%(")
      or line:match("^func%s+%((%w+)?%s*%w+%s+%)(%w+)%(")
      or line:match("^func%s+(%w+)%(")
    if name and name:match("^Test") then
      table.insert(names, name)
    end
  end

  return names
end

local function test_run_filter(name)
  if not name or name == "" then
    return nil
  end
  return "^" .. name .. "$"
end

local function test_names_filter(names)
  if vim.tbl_isempty(names) then
    return nil
  end
  return "^(" .. table.concat(names, "|") .. ")$"
end

function M.test_package(bufnr, extra_args)
  bufnr = bufnr or 0
  run_in_terminal(gotestsum_cmd(relative_package(bufnr), extra_args), bufnr)
end

function M.test_all(bufnr, extra_args)
  bufnr = bufnr or 0
  run_in_terminal(gotestsum_cmd("./...", extra_args), bufnr, "go-test-all")
end

function M.test_file(bufnr, extra_args)
  bufnr = bufnr or 0
  local names = test_names_in_buffer(bufnr)
  if vim.tbl_isempty(names) then
    vim.notify("No Test* functions in current buffer", vim.log.levels.WARN)
    return
  end

  run_in_terminal(gotestsum_cmd(relative_package(bufnr), extra_args, test_names_filter(names)), bufnr, "go-test-file")
end

function M.test_func(bufnr, extra_args)
  bufnr = bufnr or 0
  local name = function_name_at_cursor(bufnr)
  if not name then
    vim.notify("No function at cursor", vim.log.levels.WARN)
    return
  end

  if not name:match("^Test") then
    vim.notify("Cursor is not on a Test* function: " .. name, vim.log.levels.WARN)
    return
  end

  run_in_terminal(gotestsum_cmd(relative_package(bufnr), extra_args, test_run_filter(name)), bufnr, "go-test-func")
end

function M.test_watch(bufnr, scope)
  bufnr = bufnr or 0
  scope = scope or relative_package(bufnr)

  if vim.fn.executable("gotestsum") == 0 then
    vim.notify("gotestsum not found", vim.log.levels.ERROR)
    return
  end

  run_in_terminal("gotestsum --watch --format " .. GOTESTSUM_FORMAT .. " " .. scope, bufnr, "gotestsum-watch")
end

function M.debug_test(opts)
  opts = opts or {}
  local ok, dap_go = pcall(require, "dap-go")
  if not ok then
    vim.notify("nvim-dap-go is not loaded", vim.log.levels.ERROR)
    return
  end

  dap_go.debug_test(opts)
end

function M.setup_commands()
  vim.api.nvim_create_user_command("GoTest", function(opts)
    M.test_package(0, opts.args)
  end, {
    desc = "Run tests in current package",
    nargs = "*",
  })

  vim.api.nvim_create_user_command("GoTestAll", function(opts)
    M.test_all(0, opts.args)
  end, {
    desc = "Run all tests in module",
    nargs = "*",
  })

  vim.api.nvim_create_user_command("GoTestFile", function(opts)
    M.test_file(0, opts.args)
  end, {
    desc = "Run tests declared in current file",
    nargs = "*",
  })

  vim.api.nvim_create_user_command("GoTestFunc", function(opts)
    M.test_func(0, opts.args)
  end, {
    desc = "Run Test* function at cursor",
    nargs = "*",
  })

  vim.api.nvim_create_user_command("GoTestWatch", function(opts)
    local scope = opts.args ~= "" and opts.args or nil
    M.test_watch(0, scope)
  end, {
    desc = "Watch tests with gotestsum (optional package scope)",
    nargs = "?",
    complete = "file",
  })

  vim.api.nvim_create_user_command("GoDebugTest", function(opts)
    M.debug_test({
      subtest = opts.fargs[1] == "subtest",
    })
  end, {
    desc = "Debug nearest Go test (GoDebugTest subtest for subtests)",
    nargs = "?",
    complete = function()
      return { "subtest" }
    end,
  })
end

-- Alternate between foo.go and foo_test.go; creates the test file if missing.
local function package_name(filename)
  local directory = vim.fs.dirname(filename)
  return (vim.fs.basename(directory):gsub("[^%w_]", "_"))
end

local function alternate_file(filename)
  if filename:match("_test%.go$") then
    return (filename:gsub("_test%.go$", ".go"))
  end
  return (filename:gsub("%.go$", "_test.go"))
end

function M.open_alternate(bufnr, command)
  local current = vim.api.nvim_buf_get_name(bufnr)
  local alternate = alternate_file(current)

  if vim.fn.filereadable(alternate) == 0 and alternate:match("_test%.go$") then
    vim.fn.writefile({ "package " .. package_name(current) }, alternate)
  end

  vim.cmd(command .. " " .. vim.fn.fnameescape(alternate))
end

function M.code_action_by_kind(kind, apply)
  vim.lsp.buf.code_action({
    apply = apply,
    filter = function(action)
      return action.kind == kind
    end,
  })
end

-- golangci-lint uses the project config; when there is none, fall back to
-- config/golangci.yml from dotfiles.
local GOLANGCI_CONFIGS = { ".golangci.yml", ".golangci.yaml", ".golangci.toml", ".golangci.json" }

local function golangci_config_args(root)
  if #vim.fs.find(GOLANGCI_CONFIGS, { upward = true, path = root, limit = 1 }) > 0 then
    return {}
  end

  local dotfiles_config = vim.fs.dirname(vim.fn.resolve(vim.fn.stdpath("config")))
  local fallback = vim.fs.joinpath(dotfiles_config, "golangci.yml")
  if vim.fn.filereadable(fallback) == 1 then
    return { "--config", fallback }
  end
  return {}
end

function M.lint_terminal(bufnr)
  local root = M.current_root(bufnr)
  local args = vim.list_extend({ "golangci-lint", "run" }, golangci_config_args(root))
  local escaped = vim.tbl_map(vim.fn.shellescape, args)
  require("config.terminal").run({
    cmd = table.concat(escaped, " "),
    cwd = root,
    slot = "go-lint",
    height = TERMINAL_HEIGHT,
  })
end

function M.lint_quickfix(bufnr)
  local root = M.current_root(bufnr)
  local cmd = vim.list_extend({ "golangci-lint", "run", "--output.json.path", "stdout" }, golangci_config_args(root))

  vim.system(cmd, { cwd = root, text = true }, function(result)
    vim.schedule(function()
      local ok, decoded = pcall(vim.json.decode, result.stdout or "")
      if not ok or not decoded then
        vim.notify("golangci-lint: failed to parse output\n" .. (result.stderr or ""), vim.log.levels.ERROR)
        return
      end

      local items = {}
      for _, issue in ipairs(decoded.Issues or {}) do
        local filename = issue.Pos.Filename
        if not vim.startswith(filename, "/") then
          filename = vim.fs.joinpath(root, filename)
        end
        table.insert(items, {
          filename = filename,
          lnum = issue.Pos.Line,
          col = issue.Pos.Column,
          text = string.format("[%s] %s", issue.FromLinter, issue.Text),
        })
      end

      vim.fn.setqflist({}, " ", { title = "golangci-lint", items = items })
      if #items > 0 then
        vim.cmd("copen")
      else
        vim.notify("golangci-lint: no issues", vim.log.levels.INFO)
      end
    end)
  end)
end

return M
