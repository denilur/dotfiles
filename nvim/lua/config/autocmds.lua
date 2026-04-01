vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.sql", "*.sqlm" },
  callback = function()
    vim.cmd("silent !sqlfluff format % --write-output")
  end,
})

    local function toggle_diagnostics()
      local is_enabled= vim.diagnostic.is_enabled()

      if is_enabled then
        vim.diagnostic.enable(false)
      else
        vim.diagnostic.enable(true)
      end
    end

    vim.keymap.set("n", "<leader>ud", toggle_diagnostics, { desc = "Toggle diagnostics" })
