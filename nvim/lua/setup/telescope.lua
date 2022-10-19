require('telescope').setup({
  defaults = {
    layout_strategy = "vertical",
    file_ignore_patterns = { "vendor" }
  },
  pickers = {
    buffers = {
      sort_lastused = true,
      mappings = {
        i = {
          ["<c-d>"] = "delete_buffer",
        }
      }
    },
  },
})
