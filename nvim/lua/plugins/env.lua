return {
  {
    "t3ntxcl3s/ecolog.nvim",
    enabled = false,
    vscode = false,
    keys = {
      { "<leader>fv", "<cmd>EcologGoto<cr>", desc = "Go to .env file" },
      { "<localleader>ep", "<cmd>EcologPeek<cr>", desc = "Peek .env variable" },
      { "<localleader>es", "<cmd>EcologSelect<cr>", desc = "Switch .env file" },
    },
    -- Lazy loading is done internally
    lazy = false,
    opts = {},
    config = function(_, opts)
      require("which-key").add({
        { "<localleader>e", desc = "+Ecolog (.env)", icon = "" },
      })
      require("ecolog").setup(opts)
    end,
  },
}
