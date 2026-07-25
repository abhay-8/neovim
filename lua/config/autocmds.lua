local group = vim.api.nvim_create_augroup("UserAutoCmds", { clear = true })

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  callback = function()
    local file = vim.api.nvim_buf_get_name(0)
    -- Ignore oil, terminal, and other special buffers that use protocols (://)
    if file ~= "" and not file:match("^%a+://") and vim.fn.filereadable(file) == 0 then
      vim.cmd("bdelete!")
    end
  end,
})

-- Prevent LSP and heavy plugins from attaching to oil buffers (God IDE optimization)
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "oil",
  callback = function()
    vim.b.gutentags_enabled = 0
    vim.opt_local.spell = false
    -- You can add other buffer-local plugin disables here if needed
  end,
})
