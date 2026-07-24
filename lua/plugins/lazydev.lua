return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      { path = "luvit-meta/library", words = { "vim%.uv" } },
    },
  },
  config = function(_, opts)
    require("lazydev").setup(opts)

    -- Patch workspace.root_dir to guard against nil client.root_dir.
    -- Without this, opening a file via Neo-tree (or any non-lua buffer)
    -- can crash when an already-attached lua_ls client has root_dir = nil.
    local ok, Workspace = pcall(require, "lazydev.workspace")
    if ok then
      local Util = require("lazydev.util")
      Workspace.root_dir = function(self)
        local client = self:client()
        if client and client.root_dir and Util.norm(client.root_dir) == self.root then
          return client.root_dir
        end
        return self.root
      end
    end
  end,
}
