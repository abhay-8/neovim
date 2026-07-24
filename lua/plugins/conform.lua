return {
  "stevearc/conform.nvim",

  opts = {
    formatters_by_ft = {
      javascript = { "prettierd" },
      typescript = { "prettierd" },
      javascriptreact = { "prettierd" },
      typescriptreact = { "prettierd" },
      json = { "prettierd" },
      css = { "prettierd" },
      html = { "prettierd" },
      markdown = { "prettierd" },
      yaml = { "prettierd" },
    },
  },

  config = function(_, opts)
    require("conform").setup(opts)

    -- format selection only
    vim.keymap.set("v", "<leader>fp", function()
      require("conform").format({
        async = false,
        lsp_fallback = false,
      })
    end, { desc = "Format selection" })

    -- optional: full file format
    vim.keymap.set("n", "<leader>fP", function()
      require("conform").format({
        async = false,
        lsp_fallback = false,
      })
    end, { desc = "Format file" })
  end,
}
