return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",

    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },

    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Load snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      -- 🔥 LSP capabilities (REQUIRED for completion + auto-import)
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      _G.cmp_capabilities = capabilities

      cmp.setup({
        completion = {
          autocomplete = true, -- VSCode-like auto popup
        },

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        mapping = cmp.mapping.preset.insert({
          -- manual trigger (fallback)
          ["<C-l>"] = cmp.mapping.complete(),

          -- close
          ["<C-e>"] = cmp.mapping.abort(),

          -- confirm selection
          ["<CR>"] = cmp.mapping.confirm({
            select = true,
            behavior = cmp.ConfirmBehavior.Replace,
          }),

          -- next item / snippet jump
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          -- previous item / snippet back
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        sources = cmp.config.sources({
          { name = "nvim_lsp" }, -- 🔥 LSP (JS, Ruby, Java etc.)
          { name = "path" },     -- 🔥 ./ file paths
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }),

        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              buffer = "[BUF]",
              path = "[PATH]",
              luasnip = "[SNIP]",
            })[entry.source.name]
            return vim_item
          end,
        },
      })

      -- 🔥 AUTO-IMPORT AFTER CONFIRM (VSCode behavior)
      cmp.event:on("confirm_done", function(evt)
        local entry = evt.entry
        if not entry then return end

        vim.defer_fn(function()
          vim.lsp.buf.code_action({
            apply = true,
            context = {
              only = {
                "source.addMissingImports",
                "source.organizeImports",
              },
            },
          })
        end, 100)
      end)

      -- 🔧 CMDLINE SUPPORT (optional but nice)
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "path" },
          { name = "cmdline" },
        },
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
    end,
  },
}