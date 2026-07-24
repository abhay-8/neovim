-- Claude Code IDE integration: https://github.com/coder/claudecode.nvim
-- Requires Claude Code CLI (`claude`) in PATH. Depends on folke/snacks.nvim (LazyVim).
return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      {
        "<leader>ag",
        function()
          local modified = vim.fn.systemlist("git diff --name-only")
          for _, file in ipairs(modified) do
            if file ~= "" then
              vim.cmd("ClaudeCodeAdd " .. vim.fn.fnameescape(file))
            end
          end
          vim.notify("Added " .. #modified .. " modified file(s) to Claude")
        end,
        desc = "Add modified files to Claude",
      },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      -- <leader>ad is Legendary "Alpha dashboard"; use aD for deny (upstream uses ad)
      { "<leader>aD", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
}
