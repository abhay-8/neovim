local group = vim.api.nvim_create_augroup("UserAutoCmds", { clear = true })

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  callback = function()
    local file = vim.api.nvim_buf_get_name(0)
    if file ~= "" and vim.fn.filereadable(file) == 0 then
      vim.cmd("bdelete!")
    end
  end,
})
