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
  local fzf = require("fzf-lua")
  local repos = M.get_repos()

  if #repos == 0 then
    vim.notify("No git repositories found in " .. M.base_path, vim.log.levels.WARN)
    return
  end

  local fzf_items = {}
  local repo_map = {}
  for _, repo in ipairs(repos) do
    table.insert(fzf_items, repo.name)
    repo_map[repo.name] = repo
  end

  fzf.fzf_exec(fzf_items, {
    prompt = "Switch Repository> ",
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then return end
        local selection = repo_map[selected[1]]
        
        -- Change directory to the selected repo
        vim.cmd("cd " .. vim.fn.fnameescape(selection.path))

        -- Close any floating windows (e.g., snacks-explorer)
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_config(win).relative ~= "" then
            vim.api.nvim_win_close(win, true)
          end
        end

        -- Open Oil for the new directory
        require("oil").open(selection.path)

        vim.notify("Switched to " .. selection.name)
      end,
    },
  })
end

return M
