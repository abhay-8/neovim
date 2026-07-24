-- Disable LazyVim's default UI plugins that might cause conflicts
return {
  -- Disable LazyVim's bufferline if it's causing issues
  { "akinsho/bufferline.nvim", enabled = false },
  
  -- Disable LazyVim's lualine if you want (optional)
  -- { "nvim-lualine/lualine.nvim", enabled = false },
  
  -- Disable LazyVim's alpha dashboard if you have your own
  -- { "goolord/alpha-nvim", enabled = false },
}
