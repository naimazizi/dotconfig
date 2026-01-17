return {
  {
    "dmtrKovalenko/fff.nvim",
    vscode = false,
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    opts = {
      prompt = " ",
      title = "Find Files",
    },
    lazy = false,
  },
}
