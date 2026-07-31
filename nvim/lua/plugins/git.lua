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
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
      { "<leader>gG", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit current file" },
      { "<leader>gf", "<cmd>LazyGitFilter<cr>", desc = "LazyGit filter" },
    },
    init = function()
      vim.g.lazygit_floating_window_scaling_factor = 0.9
      vim.g.lazygit_use_neovim_remote = 1
    end,
  },
  {
    "harrisoncramer/gitlab.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    build = function()
      require("gitlab").build()
    end,
    config = function()
      require("gitlab").setup({
        keymaps = {
          global = {
            add_assignee = "<localleader>laa",
            delete_assignee = "<localleader>lad",
            add_label = "<localleader>lla",
            delete_label = "<localleader>lld",
            add_reviewer = "<localleader>lra",
            delete_reviewer = "<localleader>lrd",
            approve = "<localleader>lA",
            revoke = "<localleader>lR",
            merge = "<localleader>lM",
            set_auto_merge = "<localleader>lm",
            rebase = "<localleader>lrr",
            rebase_skip_ci = "<localleader>lrs",
            rebase_force = "<localleader>lrf",
            create_mr = "<localleader>lC",
            choose_merge_request = "<localleader>lc",
            start_review = "<localleader>lS",
            reload_review = "<localleader>l<C-R>",
            summary = "<localleader>ls",
            copy_mr_url = "<localleader>lu",
            open_in_browser = "<localleader>lo",
            create_note = "<localleader>ln",
            pipeline = "<localleader>lp",
            toggle_discussions = "<localleader>ld",
            toggle_draft_mode = "<localleader>lD",
            publish_all_drafts = "<localleader>lP",
          },
        },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>g", group = "Git" },
        { "<leader>gg", desc = "LazyGit" },
        { "<leader>gG", desc = "LazyGit current file" },
        { "<leader>gf", desc = "LazyGit filter" },
        { "<leader>gs", desc = "Stage hunk" },
        { "<leader>gr", desc = "Reset hunk" },
        { "<leader>gp", desc = "Preview hunk" },
        { "<leader>gu", desc = "Undo stage hunk" },
        { "<leader>gS", desc = "Stage buffer" },
        { "<leader>gR", desc = "Reset buffer" },
        { "<localleader>l", group = "GitLab" },
        { "<localleader>lc", desc = "Choose MR" },
        { "<localleader>lS", desc = "Start review" },
        { "<localleader>ls", desc = "MR summary" },
        { "<localleader>ld", desc = "Toggle discussions" },
        { "<localleader>lp", desc = "Pipeline" },
        { "<localleader>lC", desc = "Create MR" },
        { "<localleader>lA", desc = "Approve MR" },
        { "<localleader>lR", desc = "Revoke approval" },
        { "<localleader>lM", desc = "Merge MR" },
        { "<localleader>lo", desc = "Open MR in browser" },
        { "<localleader>lu", desc = "Copy MR URL" },
      },
    },
  },
}
