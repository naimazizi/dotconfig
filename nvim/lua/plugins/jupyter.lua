return {
  -- Disable jupynvim for now
  {
    "sheng-tse/jupynvim",
    enabled = true,
    event = "BufReadPre *.ipynb",
    build = function(plugin)
      local install = loadfile(plugin.dir .. "/lua/jupynvim/install.lua")()
      install.run(plugin)
    end,
    config = function()
      require("jupynvim").setup({
        log_level = "info",
        image_renderer = "placeholder",

        remote = {
          workbench = {
            host = "user@cluster.example.edu", -- or an ~/.ssh/config Host alias
            core_path = "~/.local/bin/jupynvim-core",
            -- ssh_args = { "-J", "jumpbox" },    -- optional ProxyJump etc.
          },
        },
      })
    end,
  },
}
