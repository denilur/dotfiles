vim.api.nvim_create_user_command("AIChatCodeEdit", function(opts)
  vim.cmd("'<,'>!aichat --code --role \\%nvim-code-edit\\% " .. opts.args)
end, {
  range = true,
  nargs = 1,
  desc = "Run AIChat code edit on the selected range with the provided arguments",
})
