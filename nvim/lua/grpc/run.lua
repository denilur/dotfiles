local api = vim.api
local buffer = require("grpc-nvim.buffer")
local env = require("grpc.env")
local Job = require("plenary.job")
local request = require("grpc-nvim.request")

local M = {}

local buffer_name = "grpc_nvim_results"
local result_width_ratio = 0.3
local namespace = api.nvim_create_namespace("grpc-nvim")
local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

local function apply_env(req)
  local values, path = env.load_for_buffer(0)
  if not path then
    return req, nil
  end

  req.args = vim.tbl_map(function(arg)
    return env.substitute(arg, values)
  end, req.args)

  if req.data then
    req.data = vim.tbl_map(function(line)
      return env.substitute(line, values)
    end, req.data)
  end

  return req, path
end

local function append_to_buf(buf)
  return function(_, line)
    api.nvim_buf_set_lines(buf, -1, -1, false, { line })
  end
end

local function draw_spinner(buf, text, id)
  local opts = { virt_text_pos = "eol", hl_mode = "combine", virt_text = { text } }
  if id then
    opts.id = id
  end
  return api.nvim_buf_set_extmark(buf, namespace, 0, 0, opts)
end

local function start_spinner(buf)
  local extmark = draw_spinner(buf, { spinner_frames[1], "Comment" })
  local timer = vim.loop.new_timer()
  local frame = 1

  timer:start(0, 150, vim.schedule_wrap(function()
    frame = frame < #spinner_frames and frame + 1 or 1
    draw_spinner(buf, { spinner_frames[frame], "Comment" }, extmark)
    vim.cmd("redraw")
  end))

  return { extmark = extmark, timer = timer }
end

local function finish_spinner(buf, exit_code, spinner)
  spinner.timer:close()
  local icon = exit_code == 0 and { "✓", "Comment" } or { "✗", "WarningMsg" }
  draw_spinner(buf, icon, spinner.extmark)
end

local function open_result_window(buf)
  local winnr = vim.fn.bufwinnr(buf)
  if winnr == -1 then
    vim.cmd("vert sb" .. buf)
  else
    vim.cmd(winnr .. "wincmd w")
  end

  api.nvim_win_set_width(api.nvim_get_current_win(), math.max(20, math.floor(vim.o.columns * result_width_ratio)))
end

local function execute_request(req, buf)
  local cb = vim.schedule_wrap(append_to_buf(buf))
  local data_args = req.data and { "-d", table.concat(req.data, "\n") } or {}
  local spinner = start_spinner(buf)

  local job = Job:new({
    command = "grpcurl",
    args = vim.fn.extend(data_args, req.args),
    on_stdout = cb,
    on_stderr = cb,
    on_exit = vim.schedule_wrap(function(_, code)
      finish_spinner(buf, code, spinner)
    end),
  })

  open_result_window(buf)

  api.nvim_buf_set_option(buf, "modifiable", true)
  job:start()
end

local function make_result_header(req)
  local header = { "// grpcurl " .. table.concat(req.args, " ") }
  if req.data then
    for _, line in ipairs(req.data) do
      table.insert(header, "// " .. line)
    end
  end
  return header
end

function M.execute_under_cursor()
  local req = request["request-from-cursor"]()
  if not req then
    return api.nvim_err_writeln("Failed to create request")
  end

  local env_path
  req, env_path = apply_env(req)

  local result_buf = buffer["get-or-create-tmp"](buffer_name)
  buffer["highlight-range"](api.nvim_get_current_buf(), api.nvim_create_namespace("grpc-nvim"), req.start, req["end"], 500)
  api.nvim_buf_set_lines(result_buf, 0, -1, false, make_result_header(req))
  execute_request(req, result_buf)

  if env_path then
    vim.notify(("Grpc env: %s"):format(env_path), vim.log.levels.INFO)
  end
end

return M
