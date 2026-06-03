--- Alabaster theme tuned for backend work (Go, SQL, Proto, YAML, JSON, Lua).
return {
  {
    "dchinmay2/alabaster.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.alabaster_dim_comments = false
      vim.g.alabaster_floatborder = true

      -- Prefer light Alabaster; override with: export NVIM_BACKGROUND=dark
      local bg = vim.env.NVIM_BACKGROUND
      if bg == "dark" or bg == "light" then
        vim.o.background = bg
      else
        vim.o.background = "light"
      end

      vim.cmd.colorscheme("alabaster")

      -- Backend: readable diagnostics and LSP popups on light background
      local hl = vim.api.nvim_set_hl
      hl(0, "DiagnosticUnderlineError", { underline = true, sp = "#c50f1f" })
      hl(0, "DiagnosticUnderlineWarn", { underline = true, sp = "#9d5d00" })
      hl(0, "DiagnosticUnderlineInfo", { underline = true, sp = "#0078d4" })
      hl(0, "LspInfoBorder", { link = "FloatBorder" })
      hl(0, "LspInfoTitle", { link = "Title" })
    end,
  },
}
