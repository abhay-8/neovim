return {
  "ahmedkhalf/project.nvim",
  config = function()
    require("project_nvim").setup({
      detection_methods = { "pattern" },
      patterns = { ".git", "Makefile", "package.json" },
    })

    -- Keymap to open the project list using fzf-lua
    vim.keymap.set("n", "<leader>fp", function()
      local projects = require("project_nvim").get_recent_projects()
      if not projects or #projects == 0 then
        vim.notify("No recent projects found", vim.log.levels.WARN)
        return
      end
      require("fzf-lua").fzf_exec(projects, {
        prompt = "Projects> ",
        actions = {
          ["default"] = function(selected)
            if selected and #selected > 0 then
              vim.cmd("cd " .. vim.fn.fnameescape(selected[1]))
              require("oil").open(selected[1])
              vim.notify("Changed directory to " .. selected[1])
            end
          end
        }
      })
    end, { desc = "Find Projects" })
  end,
}
