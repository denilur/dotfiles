local GO_FORMAT_TIMEOUT_MS = 5000
local TERMINAL_HEIGHT = 15
local GO_ROOT_MARKERS = { "go.work", "go.mod", ".git" }
local GOTESTSUM_WATCH_FORMAT = "testname"
local SQL_FORMAT_COMMAND = "sqlfluff"

local function shellescape(value)
  return vim.fn.shellescape(value)
end

local function current_root(bufnr)
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

local function package_name(filename)
  local directory = vim.fs.dirname(filename)
  local basename = vim.fs.basename(directory)
  return basename:gsub("[^%w_]", "_")
end

local function test_file_template(filename)
  return "package " .. package_name(filename) .. "\n"
end

local function alternate_go_file(filename)
  if filename:match("_test%.go$") then
    return filename:gsub("_test%.go$", ".go")
  end

  return filename:gsub("%.go$", "_test.go")
end

local function open_go_alternate(bufnr, command)
  local current = vim.api.nvim_buf_get_name(bufnr)
  local alternate = alternate_go_file(current)

  if vim.fn.filereadable(alternate) == 0 and alternate:match("_test%.go$") then
    vim.fn.writefile({ test_file_template(current) }, alternate)
  end

  vim.cmd(command .. " " .. vim.fn.fnameescape(alternate))
end

local function run_in_terminal(command, bufnr)
  require("config.terminal").run({
    cmd = command,
    cwd = current_root(bufnr or 0),
    slot = "go-test",
    height = TERMINAL_HEIGHT,
  })
end

local function run_gotestsum_watch(package, bufnr)
  require("config.terminal").run({
    cmd = "gotestsum --watch --format " .. GOTESTSUM_WATCH_FORMAT .. " " .. package,
    cwd = current_root(bufnr or 0),
    slot = "gotestsum-watch",
    height = TERMINAL_HEIGHT,
  })
end

local function gopls_clients(bufnr)
  return vim.lsp.get_clients({ bufnr = bufnr, name = "gopls" })
end

local function organize_imports(bufnr)
  local clients = gopls_clients(bufnr)
  if vim.tbl_isempty(clients) then
    return
  end

  local params = vim.lsp.util.make_range_params(0, clients[1].offset_encoding)
  params.context = { only = { "source.organizeImports" } }

  local responses = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, GO_FORMAT_TIMEOUT_MS)
  if not responses then
    return
  end

  for client_id, response in pairs(responses) do
    for _, action in pairs(response.result or {}) do
      local client = vim.lsp.get_client_by_id(client_id)
      local encoding = client and client.offset_encoding or "utf-16"

      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit, encoding)
      end

      local command = action.command
      if type(command) == "table" then
        vim.lsp.buf.execute_command(command)
      end
    end
  end
end

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function(event)
    organize_imports(event.buf)
    vim.lsp.buf.format({
      bufnr = event.buf,
      async = false,
      timeout_ms = GO_FORMAT_TIMEOUT_MS,
      filter = function(client)
        return client.name == "gopls"
      end,
    })
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.sql", "*.sqlm" },
  callback = function(event)
    if vim.fn.executable(SQL_FORMAT_COMMAND) == 0 then
      vim.notify("sqlfluff not found; skip SQL formatting", vim.log.levels.WARN)
      return
    end

    local filename = vim.api.nvim_buf_get_name(event.buf)
    vim.cmd("silent !" .. SQL_FORMAT_COMMAND .. " format " .. shellescape(filename) .. " --write-output")
    vim.cmd("checktime")
  end,
})

local function toggle_diagnostics()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

local function code_action_by_kind(kind, apply)
  vim.lsp.buf.code_action({
    apply = apply,
    filter = function(action)
      return action.kind == kind
    end,
  })
end

local function golangci_lint_quickfix(bufnr, args)
  local root = current_root(bufnr)
  args = args or { "run", "--output.json.path", "stdout" }

  vim.system(vim.list_extend({ "golangci-lint" }, args), { cwd = root, text = true }, function(result)
    vim.schedule(function()
      local unknown_flag = result.code ~= 0 and (result.stderr or ""):match("unknown flag")
      if unknown_flag and args[2] ~= "--out-format" then
        golangci_lint_quickfix(bufnr, { "run", "--out-format", "json" })
        return
      end

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

vim.keymap.set("n", "<leader>ud", toggle_diagnostics, { desc = "Toggle diagnostics" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function(event)
    local buf = event.buf
    local opts = { buffer = buf, silent = true }

    vim.keymap.set("n", "<localleader>ga", function()
      open_go_alternate(buf, "edit")
    end, vim.tbl_extend("force", opts, { desc = "Go alternate file" }))

    vim.keymap.set("n", "<localleader>gA", function()
      open_go_alternate(buf, "vsplit")
    end, vim.tbl_extend("force", opts, { desc = "Go alternate file in split" }))

    vim.keymap.set("n", "<localleader>gi", function()
      organize_imports(buf)
    end, vim.tbl_extend("force", opts, { desc = "Organize imports" }))

    local function test_package()
      run_in_terminal("go test -v " .. relative_package(buf), buf)
    end

    local function test_all()
      run_in_terminal("go test -v ./...", buf)
    end

    local function watch_package()
      run_gotestsum_watch(relative_package(buf), buf)
    end

    local function watch_all()
      run_gotestsum_watch("./...", buf)
    end

    vim.keymap.set("n", "<localleader>gt", test_package, vim.tbl_extend("force", opts, { desc = "Go test package" }))
    vim.keymap.set("n", "<localleader>gT", test_all, vim.tbl_extend("force", opts, { desc = "Go test all packages" }))
    vim.keymap.set(
      "n",
      "<localleader>gw",
      watch_package,
      vim.tbl_extend("force", opts, { desc = "Watch package tests" })
    )
    vim.keymap.set("n", "<localleader>gW", watch_all, vim.tbl_extend("force", opts, { desc = "Watch all tests" }))

    vim.keymap.set("n", "<localleader>gl", function()
      run_in_terminal("golangci-lint run", buf)
    end, vim.tbl_extend("force", opts, { desc = "Run golangci-lint" }))

    vim.keymap.set("n", "<localleader>gq", function()
      golangci_lint_quickfix(buf)
    end, vim.tbl_extend("force", opts, { desc = "golangci-lint to quickfix" }))

    vim.keymap.set("n", "<localleader>jl", function()
      code_action_by_kind("refactor.rewrite.joinLines", true)
    end, vim.tbl_extend("force", opts, { desc = "Join lines" }))
    vim.keymap.set("n", "<localleader>sl", function()
      code_action_by_kind("refactor.rewrite.splitLines", true)
    end, vim.tbl_extend("force", opts, { desc = "Split lines" }))

    vim.keymap.set({ "n" }, "<localleader>at", function()
      code_action_by_kind("source.addTest", true)
    end, vim.tbl_extend("force", opts, { desc = "Add test" }))

    vim.keymap.set("n", "<localleader>fs", function()
      code_action_by_kind("refactor.rewrite.fillStruct", false)
    end, vim.tbl_extend("force", opts, { desc = "Fill struct (choose)" }))
    vim.keymap.set("n", "<localleader>fS", function()
      code_action_by_kind("refactor.rewrite.fillStruct", true)
    end, vim.tbl_extend("force", opts, { desc = "Fill struct" }))

    vim.keymap.set({ "v", "s" }, "<localleader>em", function()
      code_action_by_kind("refactor.extract.method", true)
    end, vim.tbl_extend("force", opts, { desc = "Extract method" }))
    vim.keymap.set({ "v", "s" }, "<localleader>ef", function()
      code_action_by_kind("refactor.extract.function", true)
    end, vim.tbl_extend("force", opts, { desc = "Extract function" }))
    vim.keymap.set({ "v", "s" }, "<localleader>ec", function()
      code_action_by_kind("refactor.extract.constant", true)
    end, vim.tbl_extend("force", opts, { desc = "Extract constant" }))
    vim.keymap.set({ "v", "s" }, "<localleader>eC", function()
      code_action_by_kind("refactor.extract.constant-all", true)
    end, vim.tbl_extend("force", opts, { desc = "Extract constant (all occurrences)" }))
    vim.keymap.set({ "v", "s" }, "<localleader>ev", function()
      code_action_by_kind("refactor.extract.variable", true)
    end, vim.tbl_extend("force", opts, { desc = "Extract variable" }))
    vim.keymap.set({ "v", "s" }, "<localleader>eV", function()
      code_action_by_kind("refactor.extract.variable-all", true)
    end, vim.tbl_extend("force", opts, { desc = "Extract variable (all occurrences)" }))
  end,
})
