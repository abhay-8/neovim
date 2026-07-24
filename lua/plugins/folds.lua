-- UFO + Treesitter: folds follow syntax (functions, if/for, blocks). JS/TS/TSX also load
-- `queries/*/folds.scm` so `{ ... }` regions fold (nested inside statement folds).
-- Put cursor inside the block (or on `{` / `}`) and use `zc` / `zo` / `za` (see `:help fold-commands`).
-- Java: bundled treesitter folds already use `(block)` for `{ ... }`.
return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  event = "BufReadPost",
  config = function()
    require("ufo").setup({
      open_fold_hl_timeout = 150,
      close_fold_kinds_for_ft = {
        default = { "imports", "comment" },
      },
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
    })
    -- Recommended keymaps
    vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
  end,
}
