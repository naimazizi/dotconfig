local function uniq(list)
  local seen = {}
  local out = {}
  for _, item in ipairs(list) do
    if type(item) == "string" and item ~= "" and not seen[item] then
      seen[item] = true
      table.insert(out, item)
    end
  end
  table.sort(out)
  return out
end

return {
  {
    "mason-org/mason.nvim",
    event = "VimEnter",
    cmd = { "Mason", "MasonUpdate", "MasonInstall", "MasonUninstall" },
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    opts = function(_, opts)
      opts = opts or {}
      opts.install_root_dir = opts.install_root_dir or vim.fn.expand("~/.local/share/nvim/mason")
      opts.ui = vim.tbl_deep_extend("force", opts.ui or {}, { border = "rounded" })

      -- Allow other plugin specs to extend `ensure_installed`.
      opts.ensure_installed = opts.ensure_installed or {}
      return opts
    end,
    config = function(_, opts)
      require("mason").setup(opts)

      local mason_bin = "~/.local/share/nvim/mason/bin"
      if not vim.env.PATH:find(mason_bin, 1, true) then
        vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
      end

      -- Need to be installed by Mason.
      vim.list_extend(opts.ensure_installed, {
        "bacon",
        "bacon_ls",
        "biome",
        "codelldb",
        "debugpy",
        "emmylua_ls",
        "harper-ls",
        "jsonls",
        "marksman",
        "pyrefly",
        "ruff",
        "rumdl",
        "rust-analyzer",
        "tinymist",
        "typos-lsp",
        "typstyle",
      })
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = "VimEnter",
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
    event = "VimEnter",
    dependencies = {
      "mason-org/mason.nvim",
    },
    opts = function(_, opts)
      opts = opts or {}

      local mason_settings_tools = {}

      -- Use Mason's consolidated config list.
      local ok_settings, settings = pcall(require, "mason.settings")
      if ok_settings and type(settings.current.ensure_installed) == "table" then
        mason_settings_tools = vim.deepcopy(settings.current.ensure_installed)
      end

      local tools = vim.deepcopy(mason_settings_tools)

      opts.ensure_installed = uniq(tools)
      opts.run_on_start = true
      opts.start_delay = 0

      return opts
    end,
  },
}
