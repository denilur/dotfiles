return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = "▎",
        change = "▎",
        delete = "",
        topdelete = "",
        changedelete = "▎",
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
        end

        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.nav_hunk("next")
          end)
          return "<Ignore>"
        end, "Next hunk")

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.nav_hunk("prev")
          end)
          return "<Ignore>"
        end, "Previous hunk")

        map({ "n", "v" }, "<leader>gs", gs.stage_hunk, "Stage hunk")
        map({ "n", "v" }, "<leader>gr", gs.reset_hunk, "Reset hunk")
        map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>gb", gs.blame_line, "Blame line")
        map("n", "<leader>gB", function()
          gs.blame()
        end, "Blame file")
        map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
      end,
    },
  },
}
