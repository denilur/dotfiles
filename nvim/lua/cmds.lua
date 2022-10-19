local alias = require("utils").alias

-- Go to definition
function def()
  vim.lsp.buf.definition()
end
alias("def", "Def")

-- Toggles NERDTree.
function nt_find()
  vim.api.nvim_command("NvimTreeFindFile")
end
alias("nt_find", "F")

function diagnose()
  vim.api.nvim_command("TroubleToggle")
end
alias("diagnose", "Di")

-- Sources init.lua.
function source()
  vim.api.nvim_command("source $MYVIMRC")
end
alias("source", "Source")

-- Cuts current line and appends text without leading whitespace to the line above.
function line_up()
  local seq = vim.api.nvim_replace_termcodes(
    "^dg_k$A <Esc>pjdd",
    true,
    false,
    true
  )
  vim.api.nvim_feedkeys(seq, "n", false)
end
alias("line_up", "LU")

-- Shows the filetype.
function ft()
  vim.cmd("set filetype?")
end

-- Copies the relative file path of file in current buffer to system clipboard.
function cc_rfp()
  local full_path = vim.api.nvim_buf_get_name(0)
  local cwd = vim.fn.getcwd()
  local rfp = vim.split(full_path, string.format("%s/", cwd))[2]
  local cmd = string.format("printf %s | pbcopy", rfp)
  os.execute(cmd)
  print(rfp)
end
alias("cc_rfp", "CCP")

-- Pretty prints a Lua table.
function inspect(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, '\n'))
  return ...
end

-- Light mode
function light_mode()
  vim.g.catppuccin_flavour = "latte"
  vim.cmd [[ colorscheme catppuccin ]]
end
alias("light_mode", "Light")

function dark_mode()
  vim.g.catppuccin_flavour = "mocha"
  vim.cmd [[ colorscheme catppuccin ]]
end
alias("dark_mode", "Dark")

-- Collapses visually selected lines into single line separated by "sep".
function collapse(sep)
  local start_ln = vim.api.nvim_buf_get_mark(0, "<")[1] - 1
  local end_ln = vim.api.nvim_buf_get_mark(0, ">")[1]
  local lines = vim.api.nvim_buf_get_lines(0, start_ln, end_ln, true)

  local result = ""

  lines[1] = string.gsub(lines[1], "[ \t]+%f[\r\n%z]", "")

  for i=2, #lines do
    lines[i], _ = string.gsub(lines[i], "^%s*(.-)%s*$", "%1")
  end

  if sep then
    for i=1,#lines-1 do
      result = result .. lines[i]
      result = result .. sep
    end

    result = result .. lines[#lines]
  else
    for i=1,#lines do
      result = result .. lines[i]
    end
  end
  vim.api.nvim_buf_set_lines(0, start_ln, end_ln, true, { result })

  local curr_row = vim.api.nvim_win_get_cursor(0)[1]
  local curr_ln_len = #vim.api.nvim_get_current_line()
  vim.api.nvim_win_set_cursor(0, { curr_row, curr_ln_len })
end

-- Toggle (hide/show) diagnostics.. hack but it works
function toggle_diagnostics()
  if vim.g.diagnostics_enabled then
    vim.g.diagnostics_enabled = false
    vim.diagnostic.disable()
  else
    vim.g.diagnostics_enabled = true
    vim.diagnostic.enable()
  end
end
alias("toggle_diagnostics", "TD")
