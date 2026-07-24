return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "javascript", "typescript", "tsx",
        "java",
        "lua", "cpp", "go", "ruby", "rust",
        "json", "yaml", "html", "css",
      },
    },
  },
}
