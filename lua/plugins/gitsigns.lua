return {
  "lewis6991/gitsigns.nvim",

  opts = {
    signs = {
      add = { text = "┃" },
      change = { text = "┃" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },

    current_line_blame = true,

    current_line_blame_opts = {
      delay = 300,
      virt_text_pos = "eol",
    },

    current_line_blame_formatter =
      "<author>, <author_time:%d-%m-%Y> • <summary>",
  },

  config = function(_, opts)
    local gs = require("gitsigns")
    gs.setup(opts)

    -- navigation
    vim.keymap.set("n", "<C-g>n", gs.next_hunk, { desc = "Next hunk" })
    vim.keymap.set("n", "<C-g>p", gs.prev_hunk, { desc = "Prev hunk" })

    -- actions
    vim.keymap.set("n", "<C-g>s", gs.stage_hunk, { desc = "Stage hunk" })
    vim.keymap.set("n", "<C-g>r", gs.reset_hunk, { desc = "Reset hunk" })
    vim.keymap.set("n", "<C-g>h", gs.preview_hunk, { desc = "Preview hunk" })

    vim.keymap.set("n", "<C-g>v", gs.select_hunk, { desc = "Select hunk" })

    vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
    vim.keymap.set("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })

    -- toggle inline blame
    vim.keymap.set("n", "<leader>gb", gs.toggle_current_line_blame, { desc = "Toggle blame" })

    ----------------------------------------------------------------
    -- 🪟 Full commit popup
    ----------------------------------------------------------------
    vim.keymap.set("n", "<leader>gh", function()
      gs.blame_line({ full = true })
    end, { desc = "Full Git blame (popup)" })

    ----------------------------------------------------------------
    -- 🔍 File / repo history
    ----------------------------------------------------------------
    vim.keymap.set("n", "<leader>gf", function()
      require("fzf-lua").git_commits()
    end, { desc = "Git commits (repo)" })

    vim.keymap.set("n", "<leader>gF", function()
      require("fzf-lua").git_bcommits()
    end, { desc = "Git commits (file)" })

    ----------------------------------------------------------------
    -- 🚀 NEW: Jump to commit that introduced the line
    ----------------------------------------------------------------
    vim.keymap.set("n", "<leader>gi", function()
      gs.blame_line({ full = true })

      -- get blame info
      local blame = vim.fn.systemlist("git blame -L " ..
        vim.fn.line(".") .. "," .. vim.fn.line(".") ..
        " --porcelain")[1]

      local commit = blame and blame:match("^%w+")
      if not commit then
        print("No commit found")
        return
      end

      -- open file at that commit
      vim.cmd("edit " .. commit .. ":" .. vim.fn.expand("%"))
    end, { desc = "Go to commit that introduced this line" })
  end,
}
