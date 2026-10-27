require("yazi").setup({
  open_for_directories = false, -- directories open in oil
  enable_mouse_support = true,
  floating_window_scaling_factor = 0.9,
  yazi_floating_window_border = "rounded",
  keymaps = {
    show_help = "<f1>",
    open_file_in_vertical_split = "<c-v>",
    open_file_in_horizontal_split = "<c-s>",
    close = "q",
  },
})

vim.keymap.set("n", "//", "<cmd>Yazi<cr>", { desc = "Open yazi at current file" })
vim.keymap.set("n", "<localleader>e", "<cmd>Yazi cwd<cr>", { desc = "Open yazi at cwd" })
