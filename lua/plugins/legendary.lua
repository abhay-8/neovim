return {
  {
    "mrjones2014/legendary.nvim",
    keys = { "<leader>", "<C-p>" }, -- Lazy load on key press
    dependencies = {
      "kkharji/sqlite.lua", -- optional, but recommended for history
      "folke/which-key.nvim", -- for keybinding integration
    },
        config = function()
          local keymaps = {
            {
              "<leader>ad",
              description = "Dashboard: Open Alpha",
              mode = { "n" },
              func = function()
                vim.cmd("Alpha")
              end,
            },
          }
          require("legendary").setup({
            extensions = {
              which_key = {
                auto_register = true,
              },
            },
            keymaps = keymaps,
            commands = {},
          })
        end,
      },
    }
