-- =========================
-- LEADERS (must be first)
-- =========================
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- =========================
-- FILETYPE DETECTION
-- =========================
vim.filetype.add({
  extension = {
    jsx = "javascriptreact",
    tsx = "typescriptreact",
  },
})

-- =========================
-- GLOBAL SETTINGS
-- =========================
vim.g.autoformat = false
vim.g.lazyvim_colorscheme = "catppuccin"

-- =========================
-- BOOTSTRAP LAZYVIM
-- =========================
require("config.lazy")

-- =========================
-- AFTER LAZY LOAD (THEME + UI FIXES)
-- =========================
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    -- disable LazyVim autoformat group
    pcall(vim.api.nvim_del_augroup_by_name, "LazyFormat")

    -- ensure colorscheme is applied
    pcall(vim.cmd.colorscheme, "catppuccin")

    -- 🎨 FIX floating windows (gitsigns popup, cmp, etc.)
    local ok, cp = pcall(require, "catppuccin.palettes")
    if ok then
      local colors = cp.get_palette()

      -- main popup background
      vim.api.nvim_set_hl(0, "NormalFloat", {
        bg = colors.mantle,
      })

      -- border styling
      vim.api.nvim_set_hl(0, "FloatBorder", {
        fg = colors.blue,
        bg = colors.mantle,
      })

      -- title styling
      vim.api.nvim_set_hl(0, "FloatTitle", {
        fg = colors.lavender,
        bg = colors.mantle,
        bold = true,
      })

      -- non-focused float (optional)
      vim.api.nvim_set_hl(0, "NormalFloatNC", {
        bg = colors.mantle,
      })
    end

    -- rounded borders globally
    vim.o.winborder = "rounded"
  end,
})

-- =========================
-- GLOBAL GIT WORKFLOW KEYS
-- =========================

vim.keymap.set("n", "<leader>gn", function()
  require("gitsigns").next_hunk()
end, { desc = "Next git hunk" })

vim.keymap.set("n", "<leader>gp", function()
  require("gitsigns").prev_hunk()
end, { desc = "Prev git hunk" })

vim.keymap.set("n", "<leader>gv", function()
  require("gitsigns").select_hunk()
end, { desc = "Select git hunk" })

-- =========================
-- FORMAT (VISUAL MODE)
-- =========================
vim.keymap.set("v", "<leader>fp", function()
  require("conform").format({
    async = false,
    lsp_fallback = false,
  })
end, { desc = "Format selection" })

-- =========================
-- BUFFER NAVIGATION
-- =========================
vim.keymap.set("n", "<A-Left>", ":bprevious<CR>", { silent = true })
vim.keymap.set("n", "<A-Right>", ":bnext<CR>", { silent = true })

-- =========================
-- SPLIT NAVIGATION
-- =========================
vim.keymap.set("n", "<A-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<A-j>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<A-k>", "<C-w>k", { silent = true })
vim.keymap.set("n", "<A-l>", "<C-w>l", { silent = true })

-- =========================
-- SESSION MANAGEMENT
-- =========================
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  nested = true,
  callback = function()
    local session_file = vim.fn.getcwd() .. "/.nvim-session"

    if vim.fn.filereadable(session_file) == 1 then
      vim.cmd("source " .. vim.fn.fnameescape(session_file))
    end

    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        vim.cmd("mksession! " .. vim.fn.fnameescape(session_file))
      end,
    })
  end,
})

-- =========================
-- FIX: MISSING FILES AFTER GIT SWITCH
-- =========================
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local file = vim.api.nvim_buf_get_name(0)
    if file ~= "" and vim.fn.filereadable(file) == 0 then
      vim.cmd("bdelete!")
    end
  end,
})