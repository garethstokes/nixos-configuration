-- reference found here
-- https://www.lazyvim.org/plugins/lsp

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
        -- html = {}, -- html
        tailwindcss = {}, -- tailwind
        tsserver = {}, -- typescript
        marksman = {}, -- markdown
        nil_ls = {}, -- nix
        terraformls = {}, -- terraform
        prismals = {}, -- prisma ORM
        pyright = {}, -- python

        -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/hls.lua
        hls = {
          mason = false,
          filetypes = { "haskell", "lhaskell", "cabal" },
          settings = {
            haskell = {
              formattingProvider = "fourmolu",
              cabalFormattingProvider = "cabalfmt",
            },
          },
        },
      },
    },
  },
}
