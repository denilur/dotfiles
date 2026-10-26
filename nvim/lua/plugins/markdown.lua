return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    cmd = "Markdown",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
    config = function(_, opts)
      require("render-markdown").setup(opts)

      vim.api.nvim_create_user_command("Markdown", function(cmd_opts)
        if cmd_opts.args ~= "" then
          vim.cmd.edit(vim.fn.fnameescape(cmd_opts.args))
        end
        require("render-markdown").preview()
      end, {
        nargs = "?",
        complete = "file",
        desc = "Open markdown rendered (optional file)",
      })
    end,
  },
}
