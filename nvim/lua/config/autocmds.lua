vim.api.nvim_create_user_command("AIChatCodeEdit", function(opts)
  vim.cmd("'<,'>!aichat --code --role \\%nvim-code-edit\\% " .. opts.args)
end, {
  range = true,
  nargs = 1,
  desc = "Run AIChat code edit on the selected range with the provided arguments",
})

vim.api.nvim_create_user_command(
  "GolangCiLint",
  function(opts)
    local command = "run --fix=false --out-format=json"
    local binary = "golangci-lint"
    local fallback_binary = "bin/golangci-lint"

    if vim.fn.filereadable(fallback_binary) == 1 and vim.fn.executable(fallback_binary) then
      binary = fallback_binary
    end

    local version = vim.system({ binary, "version" }, { text = true }):wait().stdout
    if version and (version:match("version v2.0.") or version:match("version 2.0.")) then
      command = "run --fix=false --show-stats=false --output.json.path=stdout"
    elseif version and (version:match("version v2") or version:match("version 2")) then
      command = "run --fix=false --show-stats=false --output.json.path=stdout --path-mode=abs"
    end

    local current_file = vim.fn.expand("%:p")
    local current_dir = vim.fn.fnamemodify(current_file, ":h")
    local filename_only = vim.fn.expand("%:t")

    local cmd = string.format("cd %s && %s %s --config %s %s",
      vim.fn.shellescape(current_dir),
      binary,
      command,
      '~/.config/.golangci.yml',
      opts.fargs[1]
    )

    local result = vim.fn.system(cmd)

    local ns = vim.api.nvim_create_namespace("golangci-lint")
    vim.diagnostic.reset(ns)

    local ok, parsed = pcall(vim.json.decode, result)
    if not ok or not parsed then
      vim.notify("Failed to parse golangci-lint output", vim.log.levels.ERROR)
      return
    end

    local diagnostics = {}

    if parsed.Issues then
      for _, issue in ipairs(parsed.Issues) do
        local issue_filename = issue.Pos.Filename
        local is_current_file = false

        if issue_filename == current_file or
            issue_filename == filename_only or
            vim.fn.fnamemodify(issue_filename, ":p") == current_file then
          is_current_file = true
        end

        if not is_current_file and not issue_filename:match("^/") then
          local absolute_issue_path = vim.fn.fnamemodify(vim.fn.resolve(current_dir .. "/" .. issue_filename), ":p")
          if absolute_issue_path == current_file then
            is_current_file = true
          end
        end

        if is_current_file then
          local line = (issue.Pos.Line or 1) - 1
          local col = (issue.Pos.Column or 1) - 1

          local severity = vim.diagnostic.severity.INFO
          if issue.Severity == "error" then
            severity = vim.diagnostic.severity.ERROR
          elseif issue.Severity == "warning" then
            severity = vim.diagnostic.severity.WARN
          end

          table.insert(diagnostics, {
            lnum = line,
            col = col,
            end_lnum = line,
            end_col = col + 1,
            severity = severity,
            message = issue.Text .. " (" .. issue.FromLinter .. ")",
            source = "golangci-lint",
            code = issue.FromLinter,
          })
        end
      end
    end

    if #diagnostics > 0 then
      vim.diagnostic.set(ns, 0, diagnostics, {})
      require("fidget").notify(string.format("Found %d issues with golangci-lint", #diagnostics), vim.log.levels.WARN)
    else
      require("fidget").notify("No issues found with golangci-lint", vim.log.levels.INFO)
    end
  end,
  {
    nargs = 1, 
    desc = "runs golangci-lint for current buffer",
  }
)
