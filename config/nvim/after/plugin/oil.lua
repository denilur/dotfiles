-- oil: edit directories as buffers (rename/move/delete with :w).
require("oil").setup({
  default_file_explorer = true,
  view_options = { show_hidden = true },
  keymaps = {
    ["<C-t>"] = false, -- keep <C-t> for the terminal toggle
    ["<C-h>"] = false, -- keep <C-h>/<C-l> for tmux navigation
    ["<C-l>"] = false,
    ["<C-s>"] = { "actions.select", opts = { horizontal = true } },
    ["<C-v>"] = { "actions.select", opts = { vertical = true } },
    ["<C-r>"] = "actions.refresh",
  },
})

vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory (oil)" })
vim.keymap.set("n", "<leader>e", "<cmd>Oil --float<cr>", { desc = "File explorer (oil float)" })
