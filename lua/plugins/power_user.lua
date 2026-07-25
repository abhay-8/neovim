return {
  -- ==========================================================
  -- 1. HARPOON 2 (The Microservice Teleporter)
  -- ==========================================================
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      -- Keymaps
      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon: Add File" })
      vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: Quick Menu" })

      -- Instant Teleportation (<leader> + 1/2/3/4)
      vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon: Teleport to File 1" })
      vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon: Teleport to File 2" })
      vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon: Teleport to File 3" })
      vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon: Teleport to File 4" })
    end,
  },

  -- ==========================================================
  -- 2. REFACTORING.NVIM (Fowler-Style Automated Refactoring)
  -- ==========================================================
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("refactoring").setup({})

      -- Visual Mode Keymaps
      vim.keymap.set("x", "<leader>re", function() require("refactoring").refactor("Extract Function") end, { desc = "Refactor: Extract Function" })
      vim.keymap.set("x", "<leader>rv", function() require("refactoring").refactor("Extract Variable") end, { desc = "Refactor: Extract Variable" })
      vim.keymap.set("x", "<leader>ri", function() require("refactoring").refactor("Inline Variable") end, { desc = "Refactor: Inline Variable" })

      -- Normal Mode Keymaps
      vim.keymap.set("n", "<leader>ri", function() require("refactoring").refactor("Inline Variable") end, { desc = "Refactor: Inline Variable" })
      vim.keymap.set("n", "<leader>rB", function() require("refactoring").refactor("Extract Block") end, { desc = "Refactor: Extract Block" })
    end,
  },

  -- ==========================================================
  -- 3. OVERSEER.NVIM (IntelliJ / VS Code Task Runner)
  -- ==========================================================
  {
    "stevearc/overseer.nvim",
    opts = {},
    keys = {
      { "<leader>ow", "<cmd>OverseerToggle<cr>", desc = "Overseer: Toggle Task Window" },
      { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Overseer: Run Task" },
      { "<leader>ol", "<cmd>OverseerRunCmd<cr>", desc = "Overseer: Run Command" },
      { "<leader>oc", "<cmd>OverseerClose<cr>", desc = "Overseer: Close" },
    },
  },

  -- ==========================================================
  -- 4. TREESITTER CONTEXT (Sticky Headers)
  -- ==========================================================
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    opts = {
      max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
      multiline_threshold = 20, -- Maximum number of lines to show for a single context
      trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded
    },
    keys = {
      {
        "<leader>tc",
        function()
          require("treesitter-context").toggle()
        end,
        desc = "Toggle Treesitter Context (Sticky Header)",
      },
    },
  },

  -- ==========================================================
  -- 5. NEOGEN (One-Keystroke Documentation Generator)
  -- ==========================================================
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("neogen").setup({
        enabled = true,
        languages = {
          java = {
            template = {
              annotation_convention = "javadoc",
            },
          },
          cpp = {
            template = {
              annotation_convention = "doxygen",
            },
          },
        },
      })

      vim.keymap.set("n", "<leader>nf", function()
        require("neogen").generate({ type = "func" })
      end, { desc = "Neogen: Generate Function Docstring" })

      vim.keymap.set("n", "<leader>nc", function()
        require("neogen").generate({ type = "class" })
      end, { desc = "Neogen: Generate Class Docstring" })
    end,
  },

  -- ==========================================================
  -- 6. MINI.SURROUND & MINI.AI (Supercharged Vim Text Objects)
  -- ==========================================================
  {
    "nvim-mini/mini.surround",
    version = false,
    config = function()
      require("mini.surround").setup({
        -- Standard mappings:
        -- saiw) - Surround Add Inner Word with (
        -- sd'   - Surround Delete '
        -- sr)'  - Surround Replace ) with '
      })
    end,
  },
  {
    "nvim-mini/mini.ai",
    version = false,
    config = function()
      require("mini.ai").setup({
        -- Enhances a (around) and i (inside) text objects
        -- Examples: daf (delete around function), ciq (change inside quote)
      })
    end,
  },
}
