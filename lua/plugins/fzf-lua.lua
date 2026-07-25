return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local fzf = require("fzf-lua")

    fzf.setup({
      -- Set fzf-lua to use the default profile (similar to telescope defaults)
      winopts = {
        preview = {
          default = "bat",
          wrap = "nowrap",
        },
      },
      keymap = {
        builtin = {
          ["<C-f>"] = "preview-page-down",
          ["<C-b>"] = "preview-page-up",
        },
        fzf = {
          -- VSCode-like split keys
          ["ctrl-s"] = "split",
          ["ctrl-v"] = "vsplit",
          -- yank path mapping is more complex in fzf-lua but we can bind ctrl-y
        },
      },
      actions = {
        files = {
          ["default"] = fzf.actions.file_edit,
          ["ctrl-s"]  = fzf.actions.file_split,
          ["ctrl-v"]  = fzf.actions.file_vsplit,
          ["ctrl-t"]  = fzf.actions.file_tabedit,
          ["ctrl-y"]  = function(selected, opts)
            if not selected or #selected == 0 then return end
            -- The selected entry usually has the file path as the first string or matches a pattern
            local file = fzf.path.entry_to_file(selected[1], opts)
            if file and file.path then
              local rel_path = vim.fn.fnamemodify(file.path, ":.")
              vim.fn.setreg("+", rel_path)
              print("Copied: " .. rel_path)
            end
          end,
        },
      },
      files = {
        rg_opts = "--color=never --files --hidden --follow -g '!.git' -g '!node_modules/' -g '!vendor/'",
        fd_opts = "--color=never --type f --hidden --follow --exclude .git --exclude node_modules --exclude vendor",
      },
    })

    -- 🔭 fzf-lua keymaps
    vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find Files" })
    vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", { desc = "Live Grep" })
    vim.keymap.set("n", "<leader>fw", "<cmd>FzfLua grep_cword<cr>", { desc = "Search Word" })
    vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", { desc = "Buffers" })
    vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua help_tags<cr>", { desc = "Help" })
    vim.keymap.set("n", "<leader>fk", "<cmd>FzfLua keymaps<cr>", { desc = "Keymaps" })

    -- LSP
    vim.keymap.set("n", "<leader>fd", "<cmd>FzfLua lsp_definitions<cr>", { desc = "Definitions" })
    vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua lsp_references<cr>", { desc = "References" })
    vim.keymap.set("n", "<leader>fi", "<cmd>FzfLua lsp_implementations<cr>", { desc = "Implementations" })
    vim.keymap.set("n", "<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", { desc = "Symbols" })

    -- 🔍 search using yanked text
    vim.keymap.set("n", "<leader>sg", function()
      require("fzf-lua").live_grep({ search = vim.fn.getreg('"') })
    end, { desc = "Grep yanked text" })

    -- 🔍 vim search using yanked text
    vim.keymap.set("n", "<leader>/", function()
      local yanked = vim.fn.getreg('"')
      yanked = vim.fn.escape(yanked, [[\/]])
      vim.api.nvim_feedkeys("/" .. yanked, "n", false)
    end, { desc = "Search yanked text" })
  end,
}
