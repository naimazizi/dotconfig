if vim.g.vscode then
  return
end

if not vim.uv.fs_stat(".iwe") then
  return
end

vim.pack.add({ Config.gh("iwe-org/iwe.nvim") })

Config.now(function()
  -- Disable panache in favor of iwe-lsp
  vim.lsp.enable("panache", false)

  require("iwe").setup({
    mappings = {
      enable_markdown_mappings = true, -- Core markdown editing keybindings
      enable_picker_keybindings = false, -- Set to true to enable gf, gs, ga, g/, gb, gR, go
      enable_lsp_keybindings = false, -- Set to true to enable IWE-specific LSP keybindings
      enable_preview_keybindings = false, -- Set to true to enable preview keybindings
      leader = "<leader>",
      localleader = "<localleader>",
    },
    picker = {
      backend = "fzf_lua", -- "auto", "telescope", "fzf_lua", "snacks", "mini", "vim_ui"
      fallback_notify = true,
    },
    preview = {
      output_dir = vim.fn.expand("~/notes/tmp/preview"),
      temp_dir = "/tmp",
      auto_open = false,
    },
    telescope = {
      enabled = false,
    },
  })

  -- Picker keybindings
  vim.keymap.set("n", "<leader>mf", "<Plug>(iwe-picker-find-files)", { desc = "Find files" })
  vim.keymap.set("n", "<leader>ms", "<Plug>(iwe-picker-paths)", { desc = "Paths" })
  vim.keymap.set("n", "<leader>ma", "<Plug>(iwe-picker-roots)", { desc = "Roots" })
  vim.keymap.set("n", "<leader>mg", "<Plug>(iwe-picker-grep)", { desc = "Grep" })
  vim.keymap.set("n", "<leader>mb", "<Plug>(iwe-picker-blockreferences)", { desc = "Block references" })
  vim.keymap.set("n", "<leader>mr", "<Plug>(iwe-picker-backlinks)", { desc = "Backlinks" })
  vim.keymap.set("n", "<leader>mo", "<Plug>(iwe-picker-headers)", { desc = "Headers" })

  -- LSP keybindings
  vim.keymap.set("n", "<leader>md", "<Plug>(iwe-lsp-go-to-definition)", { desc = "Go to definition" })
  vim.keymap.set("v", "<leader>md", "<Plug>(iwe-lsp-link)", { desc = "Link selection" })
  vim.keymap.set("n", "<leader>mh", "<Plug>(iwe-lsp-rewrite-list-section)", { desc = "Rewrite list as section" })
  vim.keymap.set("n", "<leader>ml", "<Plug>(iwe-lsp-rewrite-section-list)", { desc = "Rewrite section as list" })

  -- Preview keybindings
  vim.keymap.set("n", "<leader>mps", "<Plug>(iwe-preview-squash)", { desc = "Squash" })
  vim.keymap.set("n", "<leader>mpe", "<Plug>(iwe-preview-export)", { desc = "Export" })
  vim.keymap.set("n", "<leader>mph", "<Plug>(iwe-preview-export-headers)", { desc = "Export headers" })
  vim.keymap.set("n", "<leader>mpw", "<Plug>(iwe-preview-export-workspace)", { desc = "Export workspace" })
end)
