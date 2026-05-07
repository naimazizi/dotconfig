return {
  -- Disable jupynvim for now
  {
    "sheng-tse/jupynvim",
    enabled = false,
    event = "BufReadPre *.ipynb",
    build = function()
      local core = vim.fn.stdpath("data") .. "/lazy/jupynvim/core"
      vim.fn.system({
        "cargo",
        "build",
        "--release",
        "--manifest-path",
        core .. "/Cargo.toml",
      })
    end,
    config = function()
      require("jupynvim").setup({
        log_level = "info",
        image_renderer = "placeholder", -- "placeholder", "kitty", or "chafa"
      })
    end,
  },
}
