return {
	{
		"mason-org/mason.nvim",
		cmd = { "Mason", "MasonUpdate", "MasonInstall", "MasonUninstall" },
		opts = {
install_root_dir = vim.fn.expand("~/.local/share/nvim/mason"),
			ui = {
				border = "rounded",
			},
		},
config = function(_, opts)
      require("mason").setup(opts)
      local mason_bin = "~/.local/share/nvim/mason/bin"
      if not vim.env.PATH:find(mason_bin, 1, true) then
        vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
      end
    end,
	},
}
