---@type vim.lsp.Config
return {
  settings = {
    gopls = {
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      analyses = {
        nilness = true,
        unusedfunc = true,
        unusedparams = true,
        unusedwrite = true,
        unreachable = true,
        useany = true,
        -- Match dotfiles/.golangci.yml staticcheck exclusions
        ST1000 = false,
        ST1003 = false,
        ST1020 = false,
        ST1021 = false,
      },
      staticcheck = true,
      gofumpt = true,
      completeUnimported = true,
      usePlaceholders = true,
      semanticTokens = false,
      diagnosticsDelay = "250ms",
      annotations = {
        bounds = true,
        escape = true,
        inline = true,
      },
    },
  },
}
