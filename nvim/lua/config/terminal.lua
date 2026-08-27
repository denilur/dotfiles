local FLOAT_WIDTH_FACTOR = 0.9
local FLOAT_HEIGHT_FACTOR = 0.85
local HORIZONTAL_HEIGHT = 15

local float = { buf = nil, win = nil }
local slots = {}

local function buf_valid(buf)
  return buf and vim.api.nvim_buf_is_valid(buf)
end

local function win_valid(win)
  return win and vim.api.nvim_win_is_valid(win)
end

local function start_job(cmd, cwd)
  local argv
  if cmd then
    argv = { vim.o.shell, "-c", cmd }
  else
    argv = { vim.o.shell }
  end

  vim.fn.jobstart(argv, { term = true, cwd = cwd })
  vim.cmd("startinsert")
end

local function open_float(buf)
  local width = math.floor(vim.o.columns * FLOAT_WIDTH_FACTOR)
  local height = math.floor(vim.o.lines * FLOAT_HEIGHT_FACTOR)
  return vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
  })
end

local M = {}

function M.toggle_float()
  if win_valid(float.win) then
    vim.api.nvim_win_hide(float.win)
    float.win = nil
    return
  end

  if buf_valid(float.buf) then
    float.win = open_float(float.buf)
    vim.cmd("startinsert")
    return
  end

  float.buf = vim.api.nvim_create_buf(true, false)
  vim.bo[float.buf].bufhidden = "hide"
  float.win = open_float(float.buf)
  vim.api.nvim_set_current_win(float.win)
  start_job(nil, vim.fn.getcwd())
end

function M.float_cmd(cmd, cwd)
  if win_valid(float.win) then
    vim.api.nvim_win_close(float.win, true)
    float.win = nil
  end
  if buf_valid(float.buf) then
    vim.api.nvim_buf_delete(float.buf, { force = true })
    float.buf = nil
  end

  float.buf = vim.api.nvim_create_buf(true, false)
  vim.bo[float.buf].bufhidden = "wipe"
  float.win = open_float(float.buf)
  vim.api.nvim_set_current_win(float.win)
  start_job(cmd, cwd or vim.fn.getcwd())
end

function M.run(opts)
  opts = opts or {}
  local slot = opts.slot or "run"
  local height = opts.height or HORIZONTAL_HEIGHT
  local existing = slots[slot]

  if existing then
    if win_valid(existing.win) then
      vim.api.nvim_win_close(existing.win, true)
    end
    if buf_valid(existing.buf) then
      vim.api.nvim_buf_delete(existing.buf, { force = true })
    end
  end

  vim.cmd("botright split")
  vim.cmd("resize " .. height)
  vim.cmd("enew")

  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  vim.bo[buf].bufhidden = "wipe"
  start_job(opts.cmd, opts.cwd or vim.fn.getcwd())

  slots[slot] = { buf = buf, win = win }
end

return M
