local fzf = require("fzf-lua")

local ROOT_MARKERS = { "go.work", "go.mod", "Makefile", ".git" }

local function project_root()
  return vim.fs.root(0, ROOT_MARKERS) or vim.uv.cwd()
end

fzf.setup({
  winopts = {
    height = 0.9,
    width = 0.8,
    preview = { layout = "vertical", vertical = "down:40%" },
  },
  keymap = {
    fzf = { ["ctrl-q"] = "select-all+accept" },
  },
  files = { hidden = true },
  grep = { hidden = true },
})

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

map("n", "<leader>ff", function()
  fzf.files({ cwd = project_root() })
end, "Find files")
map("n", "<leader>/", function()
  fzf.live_grep({ cwd = project_root() })
end, "Live grep")
map("x", "<leader>/", function()
  fzf.grep_visual({ cwd = project_root() })
end, "Grep selection")
map("n", "<leader>fw", function()
  fzf.grep_cword({ cwd = project_root() })
end, "Grep word under cursor")
map("n", "<leader>fr", fzf.resume, "Resume last picker")
map("n", "<leader>fb", fzf.buffers, "Buffers")
map("n", "<leader>fo", fzf.oldfiles, "Recent files")
map("n", "<leader>fs", fzf.lsp_document_symbols, "Document symbols")
map("n", "<leader>fS", fzf.lsp_live_workspace_symbols, "Workspace symbols")
map("n", "<leader>fh", fzf.helptags, "Help tags")
map("n", "<leader>fk", fzf.keymaps, "Keymaps")
map("n", "<leader>fq", fzf.quickfix, "Quickfix list")
map("n", "<leader>fa", fzf.builtin, "All pickers")
map("n", "<leader>dd", fzf.diagnostics_workspace, "Diagnostics")
map("n", "<leader>gf", fzf.git_status, "Git status")
