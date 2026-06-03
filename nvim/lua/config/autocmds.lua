vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.sql", "*.sqlm" },
  callback = function()
    vim.cmd("silent !sqlfluff format % --write-output")
  end,
})

local function toggle_diagnostics()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

vim.keymap.set("n", "<leader>ud", toggle_diagnostics, { desc = "Toggle diagnostics" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go", "gomod", "gowork" },
  callback = function(event)
    local buf = event.buf
    local opts = { buffer = buf, silent = true }

    vim.keymap.set("n", "<localleader>ga", function()
      local current = vim.api.nvim_buf_get_name(buf)
      if current:match("_test%.go$") then
        vim.cmd.edit(current:gsub("_test%.go$", ".go"))
      else
        vim.cmd.edit(current:gsub("%.go$", "_test.go"))
      end
    end, vim.tbl_extend("force", opts, { desc = "Go alternate file" }))

    vim.keymap.set("n", "<localleader>gi", function()
      vim.lsp.buf.code_action({
        context = { only = { "source.organizeImports" } },
        apply = true,
      })
    end, vim.tbl_extend("force", opts, { desc = "Organize imports" }))

    vim.keymap.set("n", "<localleader>gt", function()
      vim.cmd("split | terminal go test -v ./...")
    end, vim.tbl_extend("force", opts, { desc = "Run go test" }))
  end,
})
