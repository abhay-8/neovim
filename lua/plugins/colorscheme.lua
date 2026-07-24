return {
  -- Override LazyVim's default colorscheme configuration
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin", -- Set default colorscheme to catppuccin
    },
  },
  
  -- Disable LazyVim's default colorscheme
  { "folke/tokyonight.nvim", enabled = false },
  
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- Options: latte, frappe, macchiato, mocha
        transparent_background = false,
        integrations = {
          cmp = true,
          gitsigns = true,
          neo_tree = true,
          treesitter = true,
          telescope = true,
          which_key = true,
          native_lsp = {
            enabled = true,
          },
        },
      })

      -- Set the colorscheme
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
  