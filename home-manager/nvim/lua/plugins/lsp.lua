-- reference found here
-- https://www.lazyvim.org/plugins/lsp

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
        cssls = {},
        eslint = {},
        stylelint_lsp = {},
        html = {},
        tsserver = {},
        marksman = {},
        nil_ls = {},
        terraformls = {},

        -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/hls.lua
        hls = { 
          mason = false,
          filetypes = { 'haskell', 'lhaskell', 'cabal' },
          settings = {
            haskell = {
              formattingProvider = 'fourmolu',
              cabalFormattingProvider = 'cabalfmt',
            },
          },
        },
      },
    },
  },
}
