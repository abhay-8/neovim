-- Snacks explorer is part of `folke/snacks.nvim` (not a separate plugin). It registers
-- BufEnter for directories and conflicts with Neo-tree (`hijack_netrw_behavior`).
return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        enabled = false,
      },
    },
  },
}
  