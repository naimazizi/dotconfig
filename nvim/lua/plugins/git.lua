if vim.g.vscode then
  return
end

vim.pack.add({
  Config.gh("nvim-lua/plenary.nvim"),
  Config.gh("emrearmagan/atlas.nvim"),
  Config.gh("tanvirtin/vgit.nvim"),
})

Config.on_event("VimEnter", function()
  require("vgit").setup({
    settings = {
      scene = {
        keymaps = { quit = "q" },
      },
      signs = {
        definitions = {
          GitSignsAdd = { text = "▌", numhl = "GitSignsAdd" },
          GitSignsChange = { text = "▌", numhl = "GitSignsChange" },
          GitSignsDelete = { text = "▔", numhl = "GitSignsDelete" },
        },
      },
    },
  })

  local map = vim.keymap.set
  map("n", "<leader>gv", "<cmd>VGit buffer_diff_preview<cr>", { desc = "Preview Git changes" })
  map("n", "<leader>gb", "<cmd>VGit buffer_blame_preview<cr>", { desc = "Show line blame" })
  map("n", "<leader>gh", "<cmd>VGit buffer_history_preview<cr>", { desc = "Show file history" })
  map("n", "<leader>gs", "<cmd>VGit buffer_hunk_stage<cr>", { desc = "Stage Git hunk" })
  map("n", "<leader>gS", "<cmd>VGit buffer_unstage<cr>", { desc = "Unstage Git buffer" })
  map("n", "<leader>gr", "<cmd>VGit buffer_hunk_reset<cr>", { desc = "Reset Git hunk" })
  map("n", "<leader>gR", "<cmd>VGit buffer_reset<cr>", { desc = "Reset Git buffer" })
  map("n", "<leader>gp", "<cmd>VGit buffer_hunk_preview<cr>", { desc = "Preview Git hunk" })
  map("n", "<leader>gd", "<cmd>VGit project_diff_preview<cr>", { desc = "Preview project Git changes" })
  map("n", "<leader>gx", "<cmd>VGit toggle_diff_preference<cr>", { desc = "Toggle Git diff layout" })
  map("n", "[h", "<cmd>VGit hunk_up<cr>", { desc = "Previous Git hunk" })
  map("n", "]h", "<cmd>VGit hunk_down<cr>", { desc = "Next Git hunk" })
end)

Config.later(function()
  require("atlas").setup({
    ui = { picker = "fzf-lua" },
    pulls = {
      diff = {
        open_cmd = "AtlasDiff",
        lsp = { enabled = true },
      },
    },

    providers = {
      ---@type AtlasGitHubConfig
      github = {
        -- hostname = "github.company.com", -- Defaults to GH_HOST, then github.com.
        cache_ttl = 300, -- Set to 0 to disable caching.
      },
    },
  })

  local map = vim.keymap.set
  map("n", "<leader>go", "<cmd>Atlas<cr>", { desc = "Atlas actions" })
  map("n", "<leader>gi", "<cmd>Atlas issues github<cr>", { desc = "List GitHub Issues" })
  map("n", "<leader>gP", "<cmd>Atlas pulls github<cr>", { desc = "List GitHub PRs" })
end)
