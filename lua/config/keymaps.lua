-- =========================
-- YOUR CUSTOM KEYMAPS
-- =========================

-- ABSOLUTE OVERRIDE: Force <leader>e to open Oil and profile its load time
vim.keymap.set("n", "<leader>e", function()
  local start_time = vim.uv.hrtime()
  vim.cmd("Oil --float")
  local end_time = vim.uv.hrtime()
  local elapsed_ms = (end_time - start_time) / 1000000
  vim.notify(string.format("Oil loaded in %.2f ms", elapsed_ms), vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "Open Oil (Profiled)" })

-- Match SHORTCUTS.md: LazyVim’s default live grep is `<leader>sg` / `<leader>/` (fzf extra),
-- not `fw`, so this binding was never set by LazyVim.
vim.keymap.set("n", "<leader>fw", LazyVim.pick("live_grep"), { desc = "Live grep (root dir)" })
vim.keymap.set("n", "<leader>fW", LazyVim.pick("live_grep", { root = false }), { desc = "Live grep (cwd)" })

-- Window cycling (keep this, but avoid conflict with tmux navigation)
vim.keymap.set("n", "<leader>w", "<C-w>w", {
  noremap = true,
  silent = true,
  desc = "Cycle windows",
})

-- Dashboard
vim.keymap.set("n", "ad", ":Alpha<CR>", { desc = "Dashboard" })

-- =========================
-- PRETTIER FORMAT (unchanged, safe)
-- =========================
vim.keymap.set("v", "<leader>fp", function()
  if vim.fn.executable("prettier") ~= 1 then
    vim.notify("Prettier CLI not found in PATH", vim.log.levels.ERROR)
    return
  end

  local buf = 0
  local file = vim.api.nvim_buf_get_name(buf)
  if file == "" then
    vim.notify("Save the file before formatting", vim.log.levels.WARN)
    return
  end

  local start_pos = vim.fn.getpos("v")
  local end_pos = vim.fn.getpos(".")
  local start_line, start_col = start_pos[2], start_pos[3]
  local end_line, end_col = end_pos[2], end_pos[3]

  if start_line == 0 or end_line == 0 then
    vim.notify("Select a range first, then press <leader>fp", vim.log.levels.WARN)
    return
  end

  if start_line > end_line or (start_line == end_line and start_col > end_col) then
    start_line, end_line = end_line, start_line
    start_col, end_col = end_col, start_col
  end

  local start_offset = vim.api.nvim_buf_get_offset(buf, start_line - 1) + (start_col - 1)
  local end_offset = vim.api.nvim_buf_get_offset(buf, end_line - 1) + (end_col - 1)

  local text = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")

  local cmd = {
    "prettier",
    "--stdin-filepath",
    file,
    "--range-start",
    tostring(start_offset),
    "--range-end",
    tostring(end_offset),
  }

  local result = vim.fn.system(cmd, text)

  if vim.v.shell_error ~= 0 then
    vim.notify("Prettier failed:\n" .. result, vim.log.levels.ERROR)
    return
  end

  local new_lines = vim.split(result, "\n", { plain = true })

  if #new_lines > 0 and new_lines[#new_lines] == "" then
    table.remove(new_lines, #new_lines)
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, new_lines)
end, { desc = "Format selection with Prettier" })

-- =========================
-- IMPORTANT: TMUX NAVIGATION
-- (DO NOT override vim-tmux-navigator)
-- =========================

-- ❗ REMOVE any <C-h/j/k/l> mappings if you had them earlier
-- These must be handled by vim-tmux-navigator ONLY

local api_runner = require("custom.api_runner")
local graphql_runner = require("custom.graphql_runner")
local session = require("custom.session")

--------------------------------------------------
-- REST
--------------------------------------------------

vim.keymap.set("n", "<leader>rr", api_runner.run, {
  desc = "Run REST API endpoint",
})

--------------------------------------------------
-- GraphQL
--------------------------------------------------

vim.keymap.set("n", "<leader>gq", graphql_runner.run, {
  desc = "Run GraphQL operation",
})

--------------------------------------------------
-- Shared session
--------------------------------------------------

vim.keymap.set("n", "<leader>rc", session.clear_session, {
  desc = "Clear API session",
})

vim.keymap.set("n", "<leader>rp", session.set_port, {
  desc = "Set API port",
})

vim.keymap.set("n", "<leader>rt", session.set_token, {
  desc = "Set API token",
})

vim.keymap.set("n", "<leader>rg", session.set_graphql_endpoint, {
  desc = "Set GraphQL endpoint",
})

--------------------------------------------------
-- Pomodoro Timer & Rest Notifier
--------------------------------------------------
local pomodoro = require("custom.pomodoro")
pomodoro.setup_autotrigger()

vim.keymap.set("n", "<leader>ps", pomodoro.start, { desc = "Pomodoro: Start / Reset Timer (20 mins)" })
vim.keymap.set("n", "<leader>pt", pomodoro.status, { desc = "Pomodoro: Check Time Remaining" })
vim.keymap.set("n", "<leader>po", pomodoro.show_notification, { desc = "Pomodoro: Open Rest Window & Art" })
vim.keymap.set("n", "<leader>pc", pomodoro.stop, { desc = "Pomodoro: Stop / Cancel Timer" })
