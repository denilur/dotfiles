-- Backend stack only. Install once: :TSInstall go gomod proto sql yaml json lua bash markdown
-- Update parsers: :TSUpdate
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    cmd = { "TSUpdate", "TSInstall", "TSUninstall", "TSLog" },
    config = function()
      require("nvim-treesitter").setup()

      local group = vim.api.nvim_create_augroup("dotfiles_treesitter", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function()
          local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
          if not lang or not vim.treesitter.language.add(lang) then
            return
          end
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}
