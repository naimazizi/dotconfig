return {
  "danymat/neogen",
  cmd = "Neogen",
  event = { "BufWritePre" },
  keys = {
    {
      "<leader>cn",
      function()
        require("neogen").generate()
      end,
      desc = "Generate Annotations (Neogen)",
    },
  },
  opts = function(_, opts)
    opts.snippet_engine = "luasnip"
  end,
}
