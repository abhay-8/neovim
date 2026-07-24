return {
    "rmagatti/auto-session",
    lazy = false,
    config = function()
      require("auto-session").setup({
        auto_session_enable_last_session = false,
        auto_save_enabled = true,
        auto_restore_enabled = false,
        auto_session_use_git_branch = true,
        session_lens = {
          load_on_setup = false,
        },
      })

      -- Optional keymaps for manual session control
      vim.keymap.set("n", "<leader>ss", ":SessionSave<CR>", { desc = "Save Session" })
      vim.keymap.set("n", "<leader>sl", ":SessionRestore<CR>", { desc = "Restore Session" })
      vim.keymap.set("n", "<leader>sd", ":SessionDelete<CR>", { desc = "Delete Session" })
    end,
  }

