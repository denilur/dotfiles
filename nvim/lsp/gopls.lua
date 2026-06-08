---@type vim.lsp.Config
return {
  settings = {
    gopls = {
      hints = {
        assignVariableTypes = false,
        compositeLiteralFields = false,
        compositeLiteralTypes = false,
        constantValues = false,
        functionTypeParameters = false,
        parameterNames = false,
        rangeVariableTypes = false,
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
        bounds = false,
        escape = false,
        inline = false,
      },
    },
  },
}
