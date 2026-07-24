return {
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },

    opts = {},

    keys = {
      {
        "<leader>kr",
        function()
          require("kulala").run()
        end,
        desc = "Run HTTP request",
      },
    },
  },
}
