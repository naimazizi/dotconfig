return {
  {
    "folke/sidekick.nvim",
    vscode = false,
    opts = {
      cli = {
        mux = {
          backend = "zellij",
          enabled = true,
          create = "terminal", ---@type "terminal"|"window"|"split"
          split = {
            vertical = true, -- vertical or horizontal split
            size = 0.3, -- size of the split (0-1 for percentage)
          },
        },
        prompts = {
          fix_lang = {
            msg = "Make the sentence better and more concise",
          },
          inline_comments = {
            msg = "Add explanatory inline comments to the following code, clarifying complex logic and variable purposes",
          },
          annotate = {
            msg = "Add detailed annotations to the following code, explaining its functionality, purpose, parameter and return value follow google docstring standard if possible",
          },
        },
      },
    },
  },
}
