-- return {
--     "goolord/alpha-nvim",
--     opts = function(_, opts)
--       local dashboard = require("alpha.themes.dashboard")
  
--       -- Time-based greeting
--       local hour = tonumber(os.date("%H"))
--       local greeting
--       if hour < 12 then
--         greeting = "  Good Morning"
--       elseif hour < 18 then
--         greeting = "  Good Afternoon"
--       else
--         greeting = "  Good Evening"
--       end
  
--       -- Date string
--       local date_str = os.date("󰃭  %A, %B %d, %Y")
      
--       -- Get current folder name
--       local cwd = vim.fn.getcwd()
--       local folder_name = vim.fn.fnamemodify(cwd, ":t")
--       local folder_line = "  Currently in '" .. folder_name .. "'"
  
--       -- Header with ASCII art + greeting + date
--       dashboard.section.header.val = {
--         "       █╗    ██╗███████╗██╗      ██████╗ ██████╗ ███╗   ███╗███████╗  ",
--         "       ██║    ██║██╔════╝██║     ██╔════╝██╔═══██╗████╗ ████║██╔════╝ ",
--         "       ██║ █╗ ██║█████╗  ██║     ██║     ██║   ██║██╔████╔██║█████╗   ",
--         "       ██║███╗██║██╔══╝  ██║     ██║     ██║   ██║██║╚██╔╝██║██╔══╝   ",
--         "       ███╔███╔╝███████╗███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║███████╗ ",
--         "       ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝ ",
--         "                                                               ",
--         "",
--         "       " .. greeting,
--         "       " .. date_str,
--         "       " .. folder_line,
--         "",
--       }
  
--       -- Insert custom button
--       table.insert(dashboard.section.buttons.val, 2,
--         dashboard.button("r", "󰊢  Switch Repos", ":lua require('custom.repo_switcher').open()<CR>")
--       )
  
--       -- Layout with padding to center
--       opts.layout = {
--         { type = "padding", val = 1 },
--         dashboard.section.header,
--         { type = "padding", val = 1 },
--         dashboard.section.buttons,
--         { type = "padding", val = 1 },
--         dashboard.section.footer,
--       }
  
--       return opts
--     end,
--   }

-- 2nd cconfig
  
-- return {
--   "goolord/alpha-nvim",
--   opts = function(_, opts)
--     local dashboard = require("alpha.themes.dashboard")

--     -- Utility to get last opened project
--     local function get_last_project()
--       local path = vim.fn.stdpath("data") .. "/project_nvim/project_history"
--       local ok, lines = pcall(vim.fn.readfile, path)
--       if ok and #lines > 0 then
--         return lines[1]
--       else
--         return "No recent project found"
--       end
--     end

--     -- Time-based greeting
--     local hour = tonumber(os.date("%H"))
--     local greeting
--     if hour < 12 then
--       greeting = "  Good Morning"
--     elseif hour < 18 then
--       greeting = "  Good Afternoon"
--     else
--       greeting = "  Good Evening"
--     end

--     -- Date string
--     local date_str = os.date("󰃭  %A, %B %d, %Y")

--     -- Get current folder name
--     local cwd = vim.fn.getcwd()
--     local folder_name = vim.fn.fnamemodify(cwd, ":t")
--     local folder_line = "  Currently in '" .. folder_name .. "'"

--     -- Last opened project path
--     local last_project = get_last_project()

--     -- Header content
--     dashboard.section.header.val = {
--       "",
--       "📁  Last Opened Project:",
--       "   " .. last_project,
--       "",
--       "       " .. greeting,
--       "       " .. date_str,
--       "       " .. folder_line,
--       "",
--     }

--     -- Insert custom button
--     table.insert(dashboard.section.buttons.val, 2,
--       dashboard.button("r", "󰊢  Switch Repos", ":lua require('custom.repo_switcher').open()<CR>")
--     )

--     -- Layout
--     opts.layout = {
--       { type = "padding", val = 1 },
--       dashboard.section.header,
--       { type = "padding", val = 1 },
--       dashboard.section.buttons,
--       { type = "padding", val = 1 },
--       dashboard.section.footer,
--     }

--     return opts
--   end,
-- }

return {
  "goolord/alpha-nvim",
  opts = function(_, opts)
    local dashboard = require("alpha.themes.dashboard")

    -- Utility: Get last opened project
    local function get_last_project()
      local path = vim.fn.stdpath("data") .. "/project_nvim/project_history"
      local ok, lines = pcall(vim.fn.readfile, path)
      if ok and #lines > 0 then
        return lines[1]
      else
        return "No recent project found"
      end
    end

    -- Utility: Get last edited file (from jumplist)
    local function get_last_edited_file()
      local jumplist = vim.fn.getjumplist()[1]
      for _, entry in ipairs(jumplist) do
        if entry.filename and vim.fn.filereadable(entry.filename) == 1 then
          return vim.fn.fnamemodify(entry.filename, ":~:.")
        end
      end
      return "No recent file"
    end

    -- Utility: Get last Git commit info
    local function get_git_commit_info()
      local git_dir = vim.fn.finddir(".git", ".;")
      if git_dir == "" then
        return "Not in a Git repo"
      end

      local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
      local commit_msg = vim.fn.system("git log -1 --pretty=format:'%s'"):gsub("\n", "")
      local commit_time = vim.fn.system("git log -1 --date=relative --pretty=format:'%ad'"):gsub("\n", "")
      return string.format("  %s → %s (%s)", branch, commit_msg, commit_time)
    end

    -- Greetings
    local hour = tonumber(os.date("%H"))
    local greeting
    if hour < 12 then
      greeting = "  Good Morning"
    elseif hour < 18 then
      greeting = "  Good Afternoon"
    else
      greeting = "  Good Evening"
    end

    local date_str = os.date("󰃭  %A, %B %d, %Y")
    local cwd = vim.fn.getcwd()
    local folder_name = vim.fn.fnamemodify(cwd, ":t")
    local folder_line = "  Currently in '" .. folder_name .. "'"

    -- Gather dynamic values
    local last_project = get_last_project()
    local last_file = get_last_edited_file()
    local git_info = get_git_commit_info()

    -- Header content
    dashboard.section.header.val = {
      "",
      "📁  Last Opened Project:",
      "   " .. last_project,
      "",
      "📄  Last Edited File:",
      "   " .. last_file,
      "",
      git_info ~= "" and ("🌿  Last Commit: " .. git_info) or "",
      "",
      "       " .. greeting,
      "       " .. date_str,
      "       " .. folder_line,
      "",
    }

    -- Insert custom button
    table.insert(dashboard.section.buttons.val, 2,
      dashboard.button("r", "󰊢  Switch Repos", ":lua require('custom.repo_switcher').open()<CR>")
    )

    -- Layout
    opts.layout = {
      { type = "padding", val = 1 },
      dashboard.section.header,
      { type = "padding", val = 1 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }

    return opts
  end,
}

