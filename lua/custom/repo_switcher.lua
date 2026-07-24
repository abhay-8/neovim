local M = {}

-- Set the base folder where your repositories are stored
M.base_path = "/Users/abhaynimmagadda/dev-env"

-- Scan the base_path for git repositories
function M.get_repos()
  local base = vim.fn.expand(M.base_path)
  local handles = vim.fn.globpath(base, "*", 1, 1)
  local repos = {}

  for _, path in ipairs(handles) do
    local git_dir = path .. "/.git"
    if vim.fn.isdirectory(path) == 1 and vim.fn.isdirectory(git_dir) == 1 then
      table.insert(repos, {
        name = vim.fn.fnamemodify(path, ":t"),
        path = path,
      })
    end
  end

  return repos
end

function M.open()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local repos = M.get_repos()

  if #repos == 0 then
    vim.notify("No git repositories found in " .. M.base_path, vim.log.levels.WARN)
    return
  end

  pickers.new({}, {
    prompt_title = "Switch Repository",
    finder = finders.new_table({
      results = repos,
      entry_maker = function(repo)
        return {
          value = repo,
          display = repo.name,
          ordinal = repo.name,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        -- Change directory to the selected repo
        vim.cmd("cd " .. vim.fn.fnameescape(selection.value.path))

        -- Close any floating windows (e.g., snacks-explorer)
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_config(win).relative ~= "" then
            vim.api.nvim_win_close(win, true)
          end
        end

        -- Open Neo-tree for the new directory
        vim.cmd("Neotree filesystem reveal")

        vim.notify("Switched to " .. selection.value.name)
      end)
      return true
    end,
  }):find()
end

return M
