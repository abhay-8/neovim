return {
  "ahmedkhalf/project.nvim",
  config = function()
    require("project_nvim").setup({
      detection_methods = { "pattern" },
      patterns = { ".git", "Makefile", "package.json" },
    })

    -- Load the Telescope extension
    require("telescope").load_extension("projects")

    -- Keymap to open the project list
    vim.keymap.set("n", "<leader>fp", ":Telescope projects<CR>", { desc = "Find Projects" })
  end,
}
