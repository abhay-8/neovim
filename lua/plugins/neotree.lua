return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x", -- latest stable branch
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = false,
        sources = { "filesystem", "buffers", "git_status" },
        source_selector = {
          winbar = true,
          statusline = false,
        },
        filesystem = {
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = {},
            never_show = {},
          },
          follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
          },
          hijack_netrw_behavior = "open_default",
          use_libuv_file_watcher = true,
        },
      })

      -- Do not run `Neotree reveal` on every BufEnter: it fights with Snacks/other UI
      -- during directory startup and can recurse. `follow_current_file` above is enough.

      -- 🔧 Disable italic highlights for Git states in NeoTree
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          local groups = {
            "NeoTreeGitAdded",
            "NeoTreeGitDeleted",
            "NeoTreeGitModified",
            "NeoTreeGitUntracked",
            "NeoTreeGitStaged",
            "NeoTreeGitRenamed",
            "NeoTreeGitIgnored",
            "NeoTreeGitConflict",
            "NeoTreeGitUnstaged",
            "NeoTreeDirectoryName",
          }
          for _, group in ipairs(groups) do
            local hl = vim.api.nvim_get_hl(0, { name = group })
            hl.italic = false
            vim.api.nvim_set_hl(0, group, hl)
          end
        end,
      })

      -- 📦 Keybind to toggle NeoTree
      vim.keymap.set("n", "<leader>e", ":Neotree filesystem toggle<CR>", { noremap = true, silent = true })
    end,
  }
