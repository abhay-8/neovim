local M = {}

M.timer = nil
M.is_running = false
M.duration_ms = 20 * 60 * 1000 -- 20 minutes
M.start_time = 0
M.auto_started = false

local abstract_art = {
  -- Art 1: Cyber Portal
  {
    "       ◈  ◇  ◈  ◇  ◈  ◇  ◈  ◇  ◈       ",
    "     ◇    ◢██████████████████◣    ◇     ",
    "   ◈    ◢██████████████████████◣    ◈   ",
    "      ◢████████◤  ◈  ◥████████◣      ",
    "     ◢███████◤    ◇    ◥███████◣     ",
    "    ◢███████◤     ◈     ◥███████◣    ",
    "    ◥███████◣     ◇     ◢███████◤    ",
    "     ◥███████◣    ◈    ◢███████◤     ",
    "      ◥████████◣  ◇  ◢████████◤      ",
    "   ◈    ◥██████████████████████◤    ◈   ",
    "     ◇    ◥██████████████████◤    ◇     ",
    "       ◈  ◇  ◈  ◇  ◈  ◇  ◈  ◇  ◈       ",
  },
  -- Art 2: Zen Mountains & Sun
  {
    "              /\\                         ",
    "             /  \\     /\\                 ☀ ",
    "            /    \\   /  \\    /\\          ",
    "           /  /\\  \\ /    \\  /  \\         ",
    "          /  /  \\  \\      \\/    \\        ",
    "         /  /    \\  \\      \\     \\     ~ ~ ~",
    "        /  /      \\  \\      \\     \\   ~ ~ ~ ~",
    "       /__/________\\__\\______\\_____\\ ~ ~ ~ ~ ~",
  },
  -- Art 3: Digital Matrix Waves
  {
    "       :::====  :::====  :::====  :::====       ",
    "       :::  === :::  === :::  === :::  ===       ",
    "       ===  === ===  === ===  === ===  ===       ",
    "       ======== ======== ======== ========       ",
    "       === ==== === ==== === ==== === ====       ",
    "       ===  === ===  === ===  === ===  ===       ",
    "       ===  === ===  === ===  === ===  ===       ",
    "       ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~       ",
  },
  -- Art 4: Geometric Diamond Mandala
  {
    "                   ◈  ◇  ◈  ◇  ◈                   ",
    "                 ◇      ◈◈◈      ◇                 ",
    "               ◈     ◇◆◆◆◆◆◆◆◇     ◈               ",
    "             ◇    ◈◆◆◆◆◆◆◆◆◆◆◆◈    ◇             ",
    "           ◈    ◇◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◇    ◈           ",
    "             ◇    ◈◆◆◆◆◆◆◆◆◆◆◆◈    ◇             ",
    "               ◈     ◇◆◆◆◆◆◆◆◇     ◈               ",
    "                 ◇      ◈◈◈      ◇                 ",
    "                   ◈  ◇  ◈  ◇  ◈                   ",
  },
  -- Art 5: Cosmic Nebula
  {
    "           ☆  *    .  •    *  .  •  ☆           ",
    "       •     *  .    ✧   •      *   .           ",
    "         .  •   *  ✦  .   ☆   •  *  .           ",
    "       *   .   •   *  .  •   *  .  •            ",
    "         ☆   •  .  *   •   .  *   ✦             ",
    "       •   *  .    ☆    *  .   •   *            ",
    "           .    *    •    .  ☆   *              ",
  },
}

function M.show_notification()
  math.randomseed(vim.uv.hrtime())
  local art = abstract_art[math.random(1, #abstract_art)]

  local lines = {}
  table.insert(lines, "")
  for _, line in ipairs(art) do
    table.insert(lines, "  " .. line)
  end
  table.insert(lines, "")
  table.insert(lines, "  ================================================================")
  table.insert(lines, "")
  table.insert(lines, "                    ⏳ 20 MINUTES HAVE ELAPSED! ⏳")
  table.insert(lines, "")
  table.insert(lines, "      Take a breather. Rest your eyes, stretch, and hydrate.")
  table.insert(lines, "       Your mind compiles better after clean garbage collection!")
  table.insert(lines, "")
  table.insert(lines, "  ================================================================")
  table.insert(lines, "       [Press <Enter>, <Space>, <Esc>, or 'q' to start next cycle]")
  table.insert(lines, "")

  local max_width = 0
  for _, line in ipairs(lines) do
    max_width = math.max(max_width, vim.fn.strdisplaywidth(line))
  end

  local width = math.max(max_width + 4, 68)
  local height = #lines

  local ui = vim.api.nvim_list_uis()[1]
  local col = math.floor((ui.width - width) / 2)
  local row = math.floor((ui.height - height) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "double",
    title = " 🧠 POMODORO REST TIMER ",
    title_pos = "center",
  })

  -- Set beautiful highlights
  vim.api.nvim_set_option_value("winhl", "Normal:NormalFloat,FloatBorder:WarningMsg,FloatTitle:Title", { win = win })

  -- Close and auto-restart next cycle on keypress
  local close_and_reset = function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    M.start()
    vim.notify("🎯 Next 20-minute Pomodoro cycle started!", vim.log.levels.INFO)
  end

  for _, key in ipairs({ "<CR>", "<Space>", "<Esc>", "q" }) do
    vim.keymap.set("n", key, close_and_reset, { buf = buf, noremap = true, silent = true })
  end
end

function M.start()
  if M.timer then
    M.timer:stop()
    if not M.timer:is_closing() then
      M.timer:close()
    end
  end

  M.timer = vim.uv.new_timer()
  M.start_time = vim.uv.now()
  M.is_running = true

  M.timer:start(M.duration_ms, 0, vim.schedule_wrap(function()
    M.is_running = false
    M.show_notification()
  end))

  vim.notify("⏳ Pomodoro timer started! (20 minutes)", vim.log.levels.INFO)
end

function M.stop()
  if M.timer then
    M.timer:stop()
    if not M.timer:is_closing() then
      M.timer:close()
    end
    M.timer = nil
  end
  M.is_running = false
  vim.notify("🛑 Pomodoro timer stopped.", vim.log.levels.WARN)
end

function M.status()
  if not M.is_running then
    vim.notify("🛑 Pomodoro timer is currently stopped.", vim.log.levels.WARN)
    return
  end

  local elapsed_ms = vim.uv.now() - M.start_time
  local remaining_ms = math.max(0, M.duration_ms - elapsed_ms)
  local remaining_mins = math.floor(remaining_ms / 60000)
  local remaining_secs = math.floor((remaining_ms % 60000) / 1000)

  vim.notify(string.format("⏳ Pomodoro: %02d:%02d remaining until break!", remaining_mins, remaining_secs), vim.log.levels.INFO)
end

-- Auto-trigger timer on very first keystroke in Neovim!
function M.setup_autotrigger()
  local group = vim.api.nvim_create_augroup("PomodoroAutoTrigger", { clear = true })
  vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "TextChanged" }, {
    group = group,
    once = true,
    callback = function()
      if not M.auto_started and not M.is_running then
        M.auto_started = true
        M.start()
      end
    end,
  })
end

return M
