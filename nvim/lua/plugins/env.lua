return {
  {
    "t3ntxcl3s/ecolog.nvim",
    vscode = false,
    keys = {
      { "<leader>fv", "<cmd>EcologGoto<cr>", desc = "Go to .env file" },
      { "<localleader>ep", "<cmd>EcologPeek<cr>", desc = "Peek .env variable" },
      { "<localleader>es", "<cmd>EcologSelect<cr>", desc = "Switch .env file" },
    },
    -- Lazy loading is done internally
    lazy = false,
    opts = {
      integrations = {
        blink_cmp = true,
        fzf = {
          shelter = {
            mask_on_copy = false, -- Whether to mask values when copying
          },
        },
      },
      -- true by default, enables built-in types (database_url, url, etc.)
      types = true,
      path = vim.fn.getcwd(), -- Path to search for .env files
      preferred_environment = "development", -- Optional: prioritize specific env files
      -- Controls how environment variables are extracted from code and how cmp works
      provider_patterns = true, -- true by default, when false will not check provider patterns
    },
    config = function(_, opts)
      require("which-key").add({
        { "<localleader>e", desc = "+Ecolog (.env)", icon = "" },
      })
      require("ecolog").setup(opts)
    end,
  },
}
