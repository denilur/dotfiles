local M = {}

local ENV_FILE_NAMES = { "requests/_env.local", "_env.local" }

local function trim(value)
  return value:match("^%s*(.-)%s*$")
end

local function unquote(value)
  if value:match('^".*"$') or value:match("^'.*'$") then
    return value:sub(2, -2)
  end
  return value
end

function M.find_env_file(start_path)
  local dir = vim.fs.dirname(start_path)
  if not dir or dir == "" then
    return nil
  end

  while true do
    for _, name in ipairs(ENV_FILE_NAMES) do
      local path = vim.fs.joinpath(dir, name)
      if vim.fn.filereadable(path) == 1 then
        return path
      end
    end

    local parent = vim.fs.dirname(dir)
    if not parent or parent == dir then
      break
    end
    dir = parent
  end

  return nil
end

function M.parse_env_file(path)
  local env = {}
  local lines = vim.fn.readfile(path)

  for _, line in ipairs(lines) do
    local stripped = trim(line)
    if stripped ~= "" and not stripped:match("^#") then
      local key, value = stripped:match("^([^=]+)=(.*)$")
      if key then
        env[trim(key)] = unquote(trim(value))
      end
    end
  end

  return env
end

function M.load_for_buffer(bufnr)
  bufnr = bufnr or 0
  local filename = vim.api.nvim_buf_get_name(bufnr)
  if filename == "" then
    return {}, nil
  end

  local path = M.find_env_file(filename)
  if not path then
    return {}, nil
  end

  return M.parse_env_file(path), path
end

function M.substitute(text, env)
  if text == nil or text == "" then
    return text
  end

  return text:gsub("{{([^}]+)}}", function(key)
    local name = trim(key)
    local value = env[name]
    if value == nil then
      vim.notify(("Grpc env: missing %s"):format(name), vim.log.levels.WARN)
      return "{{" .. name .. "}}"
    end
    return value
  end)
end

return M
