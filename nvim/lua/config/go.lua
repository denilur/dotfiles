local M = {}

local GO_ROOT_MARKERS = { "go.work", "go.mod", ".git" }
local GOTESTSUM_FORMAT = "testname"
local TERMINAL_HEIGHT = 15

local function current_root(bufnr)
  bufnr = bufnr or 0
  local filename = vim.api.nvim_buf_get_name(bufnr)
  return vim.fs.root(filename, GO_ROOT_MARKERS) or vim.loop.cwd()
end

local function relative_package(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local root = current_root(bufnr)
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
    cwd = current_root(bufnr),
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

  run_in_terminal(
    gotestsum_cmd(relative_package(bufnr), extra_args, test_names_filter(names)),
    bufnr,
    "go-test-file"
  )
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

  run_in_terminal(
    gotestsum_cmd(relative_package(bufnr), extra_args, test_run_filter(name)),
    bufnr,
    "go-test-func"
  )
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

function M.setup_keymaps()
  local group = vim.api.nvim_create_augroup("dotfiles_go_tests", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "go",
    callback = function(event)
      local buf = event.buf
      local opts = { buffer = buf, silent = true }

      vim.keymap.set("n", "<leader>tt", function()
        M.test_package(buf)
      end, vim.tbl_extend("force", opts, { desc = "Test package" }))

      vim.keymap.set("n", "<leader>tT", function()
        M.test_all(buf)
      end, vim.tbl_extend("force", opts, { desc = "Test all packages" }))

      vim.keymap.set("n", "<leader>tf", function()
        M.test_file(buf)
      end, vim.tbl_extend("force", opts, { desc = "Test file" }))

      vim.keymap.set("n", "<leader>tn", function()
        M.test_func(buf)
      end, vim.tbl_extend("force", opts, { desc = "Test function" }))

      vim.keymap.set("n", "<leader>tw", function()
        M.test_watch(buf)
      end, vim.tbl_extend("force", opts, { desc = "Watch package tests" }))

      vim.keymap.set("n", "<leader>tW", function()
        M.test_watch(buf, "./...")
      end, vim.tbl_extend("force", opts, { desc = "Watch all tests" }))

      vim.keymap.set("n", "<leader>td", function()
        M.debug_test()
      end, vim.tbl_extend("force", opts, { desc = "Debug test at cursor" }))

      vim.keymap.set("n", "<localleader>gn", function()
        M.test_func(buf)
      end, vim.tbl_extend("force", opts, { desc = "Test function at cursor" }))

      vim.keymap.set("n", "<localleader>gt", function()
        M.test_package(buf)
      end, vim.tbl_extend("force", opts, { desc = "Test package" }))

      vim.keymap.set("n", "<localleader>gT", function()
        M.test_all(buf)
      end, vim.tbl_extend("force", opts, { desc = "Test all packages" }))

      vim.keymap.set("n", "<localleader>gw", function()
        M.test_watch(buf)
      end, vim.tbl_extend("force", opts, { desc = "Watch package tests" }))

      vim.keymap.set("n", "<localleader>gW", function()
        M.test_watch(buf, "./...")
      end, vim.tbl_extend("force", opts, { desc = "Watch all tests" }))

      vim.keymap.set("n", "<localleader>gm", function()
        M.debug_test()
      end, vim.tbl_extend("force", opts, { desc = "Debug test at cursor" }))
    end,
  })
end

function M.setup()
  M.setup_commands()
  M.setup_keymaps()
end

return M
