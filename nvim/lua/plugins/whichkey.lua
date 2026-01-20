return {
  {
    "folke/which-key.nvim",
    vscode = false,
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = 100,
      icons = {
        mappings = true,
      },
      spec = {
        { "<leader>a", group = "AI" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>s", group = "search" },
        { "<leader>q", group = "quit/session" },
        { "<leader>t", group = "test" },
        { "<leader>u", group = "ui" },
        { "<leader>x", group = "diagnostic" },
        { "<leader>w", group = "windows" },
        { "<leader>o", group = "overseer" },
        -- additional plugin
        { "<localleader>r", group = "REPL", icon = "" },
        { "<localleader>s", group = "Quarto", icon = "" },
        { "<localleader>c", group = "Curl (hurl)", icon = "󱂛" },
        { "gs", group = "Surround" },
        { "<leader>dP", group = "Debug Python" },
        { "<leader>h", group = "Haunting Notes", icon = "󱙝" },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Keymaps (which-key)",
      },
    },
  },
}
