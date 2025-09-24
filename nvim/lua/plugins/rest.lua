return {
  {
    "jellydn/hurl.nvim",
    event = "BufRead *.hurl",
    vscode = false,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown" },
        },
        ft = { "markdown" },
      },
    },
    ft = "hurl",
    opts = {
      -- Show debugging info
      debug = false,
      -- Show notification on run
      show_notification = false,
      -- Show response in popup or split
      mode = "split",
      -- Default formatter
      formatters = {
        json = { "jq" }, -- Make sure you have install jq in your system, e.g: brew install jq
      },
      -- Default mappings for the response popup or split views
      mappings = {
        close = "q", -- Close the response popup or split view
        next_panel = "<C-n>", -- Move to the next response popup window
        prev_panel = "<C-p>", -- Move to the previous response popup window
      },
    },
    keys = {
      -- Run API request
      { "<localleader>cC", "<cmd>HurlRunner<CR>", desc = "Run All requests" },
      { "<localleader>cc", "<cmd>HurlRunnerAt<CR>", desc = "Run Api request" },
      { "<localleader>ce", "<cmd>HurlRunnerToEntry<CR>", desc = "Run Api request to entry" },
      { "<localleader>cE", "<cmd>HurlRunnerToEnd<CR>", desc = "Run Api request from current entry to end" },
      { "<localleader>ct", "<cmd>HurlToggleMode<CR>", desc = "Hurl Toggle Mode" },
      { "<localleader>cv", "<cmd>HurlVerbose<CR>", desc = "Run Api in verbose mode" },
      { "<localleader>cV", "<cmd>HurlVeryVerbose<CR>", desc = "Run Api in very verbose mode" },
      -- Run Hurl request in visual mode
      { "<localleader>cc", ":HurlRunner<CR>", desc = "Hurl Runner", mode = "v" },
    },
    config = function(_, opts)
      require("hurl").setup(opts)
      require("which-key").add({ "<localleader>c", group = "Curl (HTTP client)", icon = "󱂛" })
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "jq" } },
  },
}
