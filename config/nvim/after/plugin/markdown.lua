require("render-markdown").setup({})

vim.api.nvim_create_user_command("Markdown", function(opts)
  if opts.args ~= "" then
    vim.cmd.edit(vim.fn.fnameescape(opts.args))
  end
  require("render-markdown").preview()
end, {
  nargs = "?",
  complete = "file",
  desc = "Open markdown rendered (optional file)",
})
