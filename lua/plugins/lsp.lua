return {
  {
    "neovim/nvim-lspconfig",

    config = function()
      local lspconfig = require("lspconfig")

      local capabilities =
        _G.cmp_capabilities or vim.lsp.protocol.make_client_capabilities()

      -- TypeScript / JavaScript
      lspconfig.vtsls.setup({
        capabilities = capabilities,

        settings = {
          -- Match VS Code keys (see vtsls configuration.schema.json). Defaults to
          -- "shortest", which with jsconfig baseUrl "." prefers imports like "client/...".
          typescript = {
            preferences = {
              importModuleSpecifier = "relative",
            },
            suggest = {
              completeFunctionCalls = true,
            },
          },

          javascript = {
            preferences = {
              importModuleSpecifier = "relative",
            },
            suggest = {
              completeFunctionCalls = true,
            },
          },
        },
      })

      -- Lua
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })

      -- JSON
      lspconfig.jsonls.setup({
        capabilities = capabilities,
      })
    end,
  },
}
