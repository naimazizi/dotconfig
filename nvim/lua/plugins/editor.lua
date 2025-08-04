return {
  {
    "hiphish/rainbow-delimiters.nvim",
    event = "BufRead",
    vscode = false,
  },
  {
    "WilliamHsieh/overlook.nvim",
    event = "BufRead",
    vscode = false,
    keys = {
      {
        "go",
        function()
          require("overlook.api").peek_definition()
        end,
        desc = "Overlook: Peek definition",
      },
      {
        "gL",
        function()
          require("overlook.api").close_all()
        end,
        desc = "Overlook: Close all popup",
      },
      {
        "gl",
        function()
          require("overlook.api").restore_popup()
        end,
        desc = "Overlook: Restore popup",
      },
    },
  },
}
