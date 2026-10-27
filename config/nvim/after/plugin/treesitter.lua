-- Parsers: :TSInstall go gomod proto sql yaml json lua bash markdown
-- They are updated automatically after vim.pack.update() (see lua/config/pack.lua).
require("nvim-treesitter").setup()

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("dotfiles_treesitter", { clear = true }),
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
    if lang and vim.treesitter.language.add(lang) then
      pcall(vim.treesitter.start, ev.buf)
    end
  end,
})

require("treesitter-context").setup({ max_lines = 4 })

require("nvim-treesitter-textobjects").setup({
  select = { lookahead = true },
  move = { set_jumps = true },
})

local select = require("nvim-treesitter-textobjects.select")
local selections = {
  af = { "@function.outer", "Select around function" },
  ["if"] = { "@function.inner", "Select inside function" },
  ac = { "@class.outer", "Select around class" },
  ic = { "@class.inner", "Select inside class" },
  aa = { "@parameter.outer", "Select around argument" },
  ia = { "@parameter.inner", "Select inside argument" },
}
for lhs, s in pairs(selections) do
  vim.keymap.set({ "x", "o" }, lhs, function()
    select.select_textobject(s[1], "textobjects")
  end, { desc = s[2] })
end

local move = require("nvim-treesitter-textobjects.move")
local moves = {
  ["]f"] = { move.goto_next_start, "Next function start" },
  ["[f"] = { move.goto_previous_start, "Previous function start" },
  ["]F"] = { move.goto_next_end, "Next function end" },
  ["[F"] = { move.goto_previous_end, "Previous function end" },
}
for lhs, m in pairs(moves) do
  vim.keymap.set({ "n", "x", "o" }, lhs, function()
    m[1]("@function.outer", "textobjects")
  end, { desc = m[2] })
end
