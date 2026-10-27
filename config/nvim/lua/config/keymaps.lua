local MAKE_TERMINAL_HEIGHT = 15

local function map(mode, lhs, rhs, desc_or_opts)
  local opts = {}
  if type(desc_or_opts) == "string" then
    opts = { desc = desc_or_opts }
  elseif type(desc_or_opts) == "table" then
    opts = desc_or_opts
  end
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

local function project_root()
  local filename = vim.api.nvim_buf_get_name(0)
  return vim.fs.root(filename, { "Makefile", "go.work", "go.mod", ".git" }) or vim.uv.cwd()
end

local function run_make(target)
  local command = target == "" and "make" or "make " .. target
  require("config.terminal").run({
    cmd = command,
    cwd = project_root(),
    slot = "make",
    height = MAKE_TERMINAL_HEIGHT,
  })
end

local function copy_path(opts)
  opts = opts or {}

  local filename = vim.api.nvim_buf_get_name(0)
  if filename == "" then
    vim.notify("No file name", vim.log.levels.WARN)
    return
  end

  local path = filename
  if not opts.absolute then
    local git_root = vim.fs.root(filename, { ".git" })
    if git_root then
      path = vim.fs.relpath(git_root, filename) or filename
    end
  end

  local text
  if opts.visual then
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    if start_line == end_line then
      text = string.format("%s:%d", path, start_line)
    else
      text = string.format("%s:%d-%d", path, start_line, end_line)
    end
  else
    local line = vim.api.nvim_win_get_cursor(0)[1]
    text = string.format("%s:%d", path, line)
  end

  vim.fn.setreg("+", text)
  vim.fn.setreg('"', text)
  vim.notify("Copied: " .. text)
end

vim.keymap.set("i", "jk", "<esc>")

vim.keymap.set({ "n", "i", "t" }, "<C-t>", function()
  require("config.terminal").toggle_float()
end, { desc = "Toggle terminal" })

vim.keymap.set("n", "<leader>cf", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format buffer" })

vim.api.nvim_create_user_command("CopyGitPath", function()
  copy_path({})
end, {
  desc = "Copy path from git root with current line",
})

map("n", "<leader>yp", function()
  copy_path({})
end, "Copy git path:line")
map("n", "<leader>yP", function()
  copy_path({ absolute = true })
end, "Copy absolute path:line")
map("x", "<leader>yp", function()
  copy_path({ visual = true })
end, "Copy git path:line-range")
map("x", "<leader>yP", function()
  copy_path({ absolute = true, visual = true })
end, "Copy absolute path:line-range")

map("n", "<leader>gg", function()
  require("config.terminal").float_cmd("lazygit", project_root())
end, "LazyGit")

map("n", "<Esc>", ":noh<CR>", "Clear highlight")

-- ]d/[d, ]q/[q, ]b/[b are Neovim defaults.
map("n", "<leader>ud", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, "Toggle diagnostics")
map("n", "<leader>dq", function()
  vim.diagnostic.setqflist({ open = true })
end, "Diagnostics to quickfix")
map("n", "<leader>qo", ":copen<CR>", "Open quickfix")
map("n", "<leader>qc", ":cclose<CR>", "Close quickfix")

map("t", "<Esc><Esc>", [[<C-\\><C-n>]], "Terminal normal mode")
map("t", "jk", [[<C-\\><C-n>]], "Terminal normal mode")

map("n", "<leader>mm", function()
  run_make("")
end, "Make")
map("n", "<leader>mt", function()
  run_make("test")
end, "Make test")
map("n", "<leader>ml", function()
  run_make("lint")
end, "Make lint")
map("n", "<leader>mb", function()
  run_make("build")
end, "Make build")
map("n", "<leader>mg", function()
  run_make("generate")
end, "Make generate")
