return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },

    config = function()
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules/", "vendor/" },
          hidden = true,

          preview = {
            treesitter = false,
          },

          mappings = {
            i = {
              -- 🔥 FIX: ensure enter opens file
              ["<CR>"] = actions.select_default,

              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,

              -- 🔥 open in splits (VSCode-like)
              ["<C-s>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,

              -- ✅ safe copy path
              ["<C-y>"] = function(prompt_bufnr)
                local entry = action_state.get_selected_entry()
                if not entry then return end

                local path = entry.path or entry.filename or entry[1]
                if not path then return end

                local rel_path = vim.fn.fnamemodify(path, ":.")
                vim.fn.setreg("+", rel_path)

                print("Copied: " .. rel_path)
              end,

              -- paste yanked text into search
              ["<C-p>"] = function(prompt_bufnr)
                local current_picker = action_state.get_current_picker(prompt_bufnr)
                local yanked = vim.fn.getreg('"')
                current_picker:reset_prompt(yanked)
              end,
            },

            n = {
              -- 🔥 FIX: ensure enter opens file
              ["<CR>"] = actions.select_default,

              ["<C-s>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,

              ["<C-y>"] = function(prompt_bufnr)
                local entry = action_state.get_selected_entry()
                if not entry then return end

                local path = entry.path or entry.filename or entry[1]
                if not path then return end

                local rel_path = vim.fn.fnamemodify(path, ":.")
                vim.fn.setreg("+", rel_path)

                print("Copied: " .. rel_path)
              end,
            },
          },
        },
      })

      -- 🔭 Telescope keymaps
      vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
      vim.keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Search Word" })
      vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help" })
      vim.keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })

      -- LSP
      vim.keymap.set("n", "<leader>fd", "<cmd>Telescope lsp_definitions<cr>", { desc = "Definitions" })
      vim.keymap.set("n", "<leader>fr", "<cmd>Telescope lsp_references<cr>", { desc = "References" })
      vim.keymap.set("n", "<leader>fi", "<cmd>Telescope lsp_implementations<cr>", { desc = "Implementations" })
      vim.keymap.set("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Symbols" })

      -- 🔍 search using yanked text
      vim.keymap.set("n", "<leader>sg", function()
        require("telescope.builtin").live_grep({
          default_text = vim.fn.getreg('"'),
        })
      end, { desc = "Grep yanked text" })

      -- 🔍 vim search using yanked text
      vim.keymap.set("n", "<leader>/", function()
        local yanked = vim.fn.getreg('"')
        yanked = vim.fn.escape(yanked, [[\/]])
        vim.api.nvim_feedkeys("/" .. yanked, "n", false)
      end, { desc = "Search yanked text" })
    end,
  },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    cond = vim.fn.executable("make") == 1,
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },
}