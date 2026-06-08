--- Alabaster theme tuned for backend work (Go, SQL, Proto, YAML, JSON, Lua).

local function apply_alabaster(background)
  vim.o.background = background
  vim.cmd.colorscheme("alabaster")

  local hl = vim.api.nvim_set_hl
  hl(0, "DiagnosticUnderlineError", { underline = true, sp = "#c50f1f" })
  hl(0, "DiagnosticUnderlineWarn", { underline = true, sp = "#9d5d00" })
  hl(0, "DiagnosticUnderlineInfo", { underline = true, sp = "#0078d4" })
  hl(0, "LspInfoBorder", { link = "FloatBorder" })
  hl(0, "LspInfoTitle", { link = "Title" })

  if background == "light" then
    hl(0, "TermCursor", { bg = "#000000", fg = "#ffffff" })
    hl(0, "TermCursorNC", { bg = "#000000", fg = "#ffffff" })
  end
end

local function fixed_background()
  local bg = vim.env.NVIM_BACKGROUND
  if bg == "dark" or bg == "light" then
    return bg
  end
  return nil
end

return {
  {
    "dchinmay2/alabaster.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.alabaster_dim_comments = false
      vim.g.alabaster_floatborder = true

      local bg = fixed_background()
      if bg then
        apply_alabaster(bg)
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
      update_interval = 3000,
      fallback = "dark",
      set_dark_mode = function()
        apply_alabaster("dark")
      end,
      set_light_mode = function()
        apply_alabaster("light")
      end,
    },
  },
}
