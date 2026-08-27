local function select(items, opts, on_choice)
  opts = opts or {}
  if vim.tbl_isempty(items) then
    on_choice(nil, nil)
    return
  end

  local format_item = opts.format_item or tostring
  local lines = {}
  for i, item in ipairs(items) do
    lines[i] = string.format("%d. %s", i, format_item(item))
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "ui-select"

  local width = 40
  for _, line in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(line) + 2)
  end
  width = math.min(width, math.floor(vim.o.columns * 0.8))
  local height = math.min(#lines, math.floor(vim.o.lines * 0.5))
  local title = (opts.prompt or "Select"):gsub(":%s*$", "")

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " " .. title .. " ",
    title_pos = "center",
  })

  local done = false
  local function finish(idx)
    if done then
      return
    end
    done = true
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    vim.schedule(function()
      if idx then
        on_choice(items[idx], idx)
      else
        on_choice(nil, nil)
      end
    end)
  end

  local map_opts = { buffer = buf, nowait = true, silent = true }
  vim.keymap.set("n", "q", function()
    finish(nil)
  end, map_opts)
  vim.keymap.set("n", "<Esc>", function()
    finish(nil)
  end, map_opts)
  vim.keymap.set("n", "<CR>", function()
    finish(vim.api.nvim_win_get_cursor(0)[1])
  end, map_opts)

  for i = 1, math.min(9, #items) do
    vim.keymap.set("n", tostring(i), function()
      finish(i)
    end, map_opts)
  end

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = buf,
    once = true,
    callback = function()
      finish(nil)
    end,
  })
end

vim.ui.select = select
