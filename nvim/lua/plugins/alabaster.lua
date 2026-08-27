--- Kanagawa theme tuned for backend work (Go, SQL, Proto, YAML, JSON, Lua).
--- Follows macOS Appearance via auto-dark-mode; override with NVIM_BACKGROUND=dark|light

local DARK_THEME = "kanagawa-wave"
local LIGHT_THEME = "kanagawa-lotus"
local DARK_BACKGROUND = "dark"
local LIGHT_BACKGROUND = "light"
local AUTO_DARK_MODE_INTERVAL_MS = 3000

local function apply_highlights(background)
  local hl = vim.api.nvim_set_hl

  hl(0, "DiagnosticUnderlineError", { underline = true, sp = "#c34043" })
  hl(0, "DiagnosticUnderlineWarn", { underline = true, sp = "#c0a36e" })
  hl(0, "DiagnosticUnderlineInfo", { underline = true, sp = "#7e9cd8" })
  hl(0, "LspInfoBorder", { link = "FloatBorder" })
  hl(0, "LspInfoTitle", { link = "Title" })

  if background == LIGHT_BACKGROUND then
    hl(0, "TermCursor", { bg = "#1f1f28", fg = "#f2ecbc" })
    hl(0, "TermCursorNC", { bg = "#1f1f28", fg = "#f2ecbc" })
  end
end

local function apply_theme(background)
  vim.o.background = background

  if background == LIGHT_BACKGROUND then
    vim.cmd.colorscheme(LIGHT_THEME)
  else
    vim.cmd.colorscheme(DARK_THEME)
  end

  apply_highlights(background)
end

local function fixed_background()
  local background = vim.env.NVIM_BACKGROUND
  if background == DARK_BACKGROUND or background == LIGHT_BACKGROUND then
    return background
  end
  return nil
end

return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      compile = false,
      undercurl = true,
      commentStyle = { italic = false },
      keywordStyle = { italic = false },
      statementStyle = { bold = false },
      transparent = false,
      dimInactive = false,
      terminalColors = true,
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)

      local background = fixed_background()
      if background then
        apply_theme(background)
      end
    end,
  },
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    priority = 1001,
    cond = function()
      return fixed_background() == nil
    end,
    opts = {
      update_interval = AUTO_DARK_MODE_INTERVAL_MS,
      fallback = DARK_BACKGROUND,
      set_dark_mode = function()
        apply_theme(DARK_BACKGROUND)
      end,
      set_light_mode = function()
        apply_theme(LIGHT_BACKGROUND)
      end,
    },
  },
}
