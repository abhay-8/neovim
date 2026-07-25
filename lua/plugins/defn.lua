return {
    -- Add telescope extension if not already included in your setup
    {
      "ibhagwan/fzf-lua",
      optional = true,
      keys = {
        {
          "<leader>gd",
          function()
            -- Try built-in go to definition first
            local ok = pcall(vim.cmd, "normal! gd")
            -- If that fails, try find_files with the word under cursor
            if not ok and package.loaded["fzf-lua"] then
              local fzf = require("fzf-lua")
              local word = vim.fn.expand("<cword>")
              pcall(fzf.grep_cword, { search = word })
            end
          end,
          desc = "Go to definition without LSP",
        },
        {
          "<leader>gf",
          function()
            -- Try built-in go to file first
            local ok = pcall(vim.cmd, "normal! gf")
            -- If that fails, try fzf-lua files with the file under cursor
            if not ok and package.loaded["fzf-lua"] then
              local fzf = require("fzf-lua")
              local file = vim.fn.expand("<cfile>")
              pcall(fzf.files, { fzf_opts = { ["--query"] = file } })
            end
          end,
          desc = "Go to file under cursor without LSP",
        },
      },
    },
    
    -- Add Universal Ctags support for better definition jumping
    {
      "ludovicchabant/vim-gutentags",
      event = "VeryLazy",
      config = function()
        -- Create the cache directory if it doesn't exist
        local cache_dir = vim.fn.expand("~/.cache/nvim/tags")
        if vim.fn.isdirectory(cache_dir) == 0 then
          vim.fn.mkdir(cache_dir, "p")
        end
        
        vim.g.gutentags_enabled = 1
        vim.g.gutentags_generate_on_new = 1
        vim.g.gutentags_generate_on_write = 1
        vim.g.gutentags_generate_on_missing = 1
        vim.g.gutentags_ctags_tagfile = ".tags"
        
        -- Set up project root markers
        vim.g.gutentags_project_root = {'.git', 'package.json', 'Cargo.toml', 'pyproject.toml'}
        
        -- Set the cache directory
        vim.g.gutentags_cache_dir = cache_dir
        
        -- Optimize for specific file types
        vim.g.gutentags_ctags_extra_args = {
          '--tag-relative=yes',
          '--fields=+ailmnS',
        }
        
        -- Add explicit file excludes to avoid any issues with wildignore
        vim.g.gutentags_exclude_filetypes = { 
          'gitcommit', 'gitconfig', 'gitrebase', 'gitsendemail', 
          'git', 'help', 'markdown', 'text', 'netrw', 'oil', 'fzf', 'lazy'
        }
        
        -- Force the use of the cache directory for options files
        vim.g.gutentags_define_advanced_commands = 1
      end,
    },
  }