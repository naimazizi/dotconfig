if vim.g.vscode then
  return
end

local function opencode_send_action(selected, opts)
  local path = require("fzf-lua.path")
  local items = vim.tbl_map(function(sel)
    local entry = path.entry_to_file(sel, opts)
    if entry and entry.path then
      return require("opencode").format({ path = entry.path, from = entry.line and { entry.line, entry.col or 0 } })
    end
    return sel
  end, selected)
  require("opencode").prompt(table.concat(items, ", ") .. " ")
end

vim.pack.add({
  Config.gh("ibhagwan/fzf-lua"),
  Config.gh("elanmed/fzf-lua-frecency.nvim"),
})

Config.later(function()
  require("fzf-lua").setup({
    { "telescope", "hide" },
    grep = {
      multiline = 2,
      rg_glob = true,
    },
    actions = {
      files = {
        ["alt-o"] = opencode_send_action,
      },
      grep = {
        ["alt-o"] = opencode_send_action,
      },
    },
  })
  require("fzf-lua").register_ui_select()

  local map = vim.keymap.set
  map("n", "<leader><leader>", function()
    require("fzf-lua-frecency").frecency({ cwd_only = true, display_score = false })
  end, { desc = "Find files" })
  map("n", "<leader>/", function()
    require("fzf-lua").live_grep()
  end, { desc = "Live Grep" })
  map("n", "<leader>sw", function()
    require("fzf-lua").grep_cword()
  end, { desc = "Search current word" })
  map("x", "<leader>sw", function()
    require("fzf-lua").grep_visual()
  end, { desc = "Search selection" })
  map("n", "<leader>sr", function()
    require("fzf-lua").resume()
  end, { desc = "Resume" })
  map("n", "<leader>sk", function()
    require("fzf-lua").keymaps()
  end, { desc = "Keymaps" })
  map("n", "<leader>sm", function()
    require("fzf-lua").marks()
  end, { desc = "Marks" })
  map("n", "<leader>sd", function()
    require("fzf-lua").diagnostics_document()
  end, { desc = "Diagnostics" })
  map("n", "<leader>sD", function()
    require("fzf-lua").diagnostics_workspace()
  end, { desc = "Diagnostics Workspace" })
  map("n", "<leader>sq", function()
    require("fzf-lua").quickfix()
  end, { desc = "Quickfix" })
  map("n", "<leader>sl", function()
    require("fzf-lua").loclist()
  end, { desc = "Loclist" })
  map("n", "<leader>fh", function()
    require("fzf-lua").help_tags()
  end, { desc = "Help" })
  map("n", "<leader>s/", function()
    require("fzf-lua").command_history()
  end, { desc = "Command History" })
  map("n", "<leader>st", function()
    require("fzf-lua").grep({ search = "\\b(TODO|FIX|FIXME|HACK|NOTE)\\b", no_esc = true })
  end, { desc = "Todo" })
  map("n", "<leader>sT", function()
    require("fzf-lua").grep({ search = "\\b(TODO|FIX|FIXME)\\b", no_esc = true })
  end, { desc = "Todo/Fix/Fixme" })
  map("n", "<leader>gc", function()
    require("fzf-lua").git_bcommits()
  end, { desc = "Show Buffer Commits" })
  map("n", "<leader>gC", function()
    require("fzf-lua").git_commits()
  end, { desc = "Show Commits" })
  map("n", "<leader>bb", function()
    require("fzf-lua").buffers()
  end, { desc = "List buffers" })
  map("n", "<leader>uc", function()
    require("fzf-lua").colorschemes()
  end, { desc = "Colorschemes" })
  map("n", "<leader>fz", function()
    require("fzf-lua").zoxide()
  end, { desc = "Zoxide" })
  map("n", "<leader>su", function()
    require("fzf-lua").undotree()
  end, { desc = "Undotree" })
  map("n", "<leader>d/", function()
    require("fzf-lua").dap_commands()
  end, { desc = "DAP Commands" })
  map("n", "<leader>dR", function()
    require("fzf-lua").dap_configurations()
  end, { desc = "DAP Configurations" })
  map("n", "<leader>dk", function()
    require("fzf-lua").dap_breakpoints()
  end, { desc = "DAP Breakpoints" })
  map("n", "<leader>dv", function()
    require("fzf-lua").dap_variables()
  end, { desc = "DAP Variables" })
  map("n", "<leader>df", function()
    require("fzf-lua").dap_frames()
  end, { desc = "DAP Frames" })
end)
