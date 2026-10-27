-- Plugins via built-in vim.pack (Neovim 0.12+). Versions are pinned in nvim-pack-lock.json.
-- Update: :lua vim.pack.update()   (review, then :write to apply)
-- Remove: drop the spec below, then :lua vim.pack.del({ "name" })

local function gh(repo)
  return "https://github.com/" .. repo
end

vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("dotfiles_pack", { clear = true }),
  callback = function(ev)
    local data = ev.data
    if data.spec.name == "nvim-treesitter" and data.kind == "update" then
      if not data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      require("nvim-treesitter").update()
    end
  end,
})

local headless = vim.tbl_contains(vim.v.argv, "--headless")

vim.pack.add({
  -- ui
  gh("IlyasYOY/theme.nvim"),
  gh("f-person/auto-dark-mode.nvim"),
  gh("nvim-tree/nvim-web-devicons"),
  gh("nvim-lualine/lualine.nvim"),
  gh("folke/which-key.nvim"),
  gh("MeanderingProgrammer/render-markdown.nvim"),

  -- editing & navigation
  gh("christoomey/vim-tmux-navigator"),
  gh("tpope/vim-surround"),
  gh("ibhagwan/fzf-lua"),
  gh("stevearc/oil.nvim"),
  gh("nvim-lua/plenary.nvim"),
  { src = gh("mikavilpas/yazi.nvim"), version = vim.version.range("*") },
  gh("lewis6991/gitsigns.nvim"),

  -- treesitter
  { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
  { src = gh("nvim-treesitter/nvim-treesitter-textobjects"), version = "main" },
  gh("nvim-treesitter/nvim-treesitter-context"),

  -- tools
  gh("williamboman/mason.nvim"),
  gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
  gh("hudclark/grpc-nvim"),

  -- debug
  gh("nvim-neotest/nvim-nio"),
  gh("mfussenegger/nvim-dap"),
  gh("rcarriga/nvim-dap-ui"),
  gh("theHamsta/nvim-dap-virtual-text"),
  gh("leoluz/nvim-dap-go"),
}, { confirm = not headless })
