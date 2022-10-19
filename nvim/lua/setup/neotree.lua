require("neo-tree").setup({
  close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
  enable_git_status = true,
  enable_diagnostics = true,
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
      hide_hidden = false,
      hide_by_name = {
        "vendor",
        "node_modules",
      },
    },
  },
})
