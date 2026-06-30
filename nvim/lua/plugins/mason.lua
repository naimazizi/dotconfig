local uniq = require("utils.table").uniq

return {
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonUpdate", "MasonInstall", "MasonUninstall" },
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    opts = function(_, opts)
      opts = opts or {}
      opts.ui = vim.tbl_deep_extend("force", opts.ui or {}, { border = "rounded" })

      -- Allow other plugin specs to extend `ensure_installed`.
      opts.ensure_installed = opts.ensure_installed or {}
      return opts
    end,
    config = function(_, opts)
      require("mason").setup(opts)

      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
      if not vim.env.PATH:find(mason_bin, 1, true) then
        vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
      end

      -- Need to be installed by Mason.
      vim.list_extend(opts.ensure_installed, {
        "bacon",
        "bacon_ls",
        "emmylua_ls",
        "harper-ls",
        "jsonls",
        "oxfmt",
        "panache",
        "pyrefly",
        "ruff",
        "rust-analyzer",
        "shfmt",
        "tinymist",
        "typos-lsp",
        "typstyle",
        "yamlls",
      })
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      automatic_installation = true,
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    cmd = {
      "MasonToolsInstall",
      "MasonToolsInstallSync",
      "MasonToolsUpdate",
      "MasonToolsUpdateSync",
      "MasonToolsClean",
    },
    dependencies = {
      "mason-org/mason.nvim",
    },
    opts = function(_, opts)
      opts = opts or {}

      local mason_settings_tools = {}

      -- Use Mason's consolidated config list.
      local ok_settings, settings = pcall(require, "mason.settings")
      if ok_settings and type(settings.current.ensure_installed) == "table" then
        mason_settings_tools = vim.deepcopy(settings.current.ensure_installed) or {}
      end

      local tools = vim.deepcopy(mason_settings_tools) or {}

      opts.ensure_installed = uniq(tools)
      opts.run_on_start = true
      opts.start_delay = 0

      return opts
    end,
  },
}
