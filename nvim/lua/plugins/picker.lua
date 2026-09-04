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

return {
  {
    "ibhagwan/fzf-lua",
    vscode = false,
    dependencies = { "elanmed/fzf-lua-frecency.nvim" },
    keys = {
      {
        "<leader><leader>",
        function()
          require("fzf-lua-frecency").frecency({ cwd_only = true, display_score = false })
        end,
        desc = "Find files",
      },
      {
        "<leader>/",
        function()
          require("fzf-lua").live_grep()
        end,
        desc = "Live Grep",
      },
      {
        "<leader>fg",
        function()
          require("fzf-lua").live_grep()
        end,
        desc = "Live Grep",
      },
      {
        "<leader>sw",
        function()
          require("fzf-lua").grep_cword()
        end,
        desc = "Search current word",
      },
      {
        "<leader>sw",
        function()
          require("fzf-lua").grep_visual()
        end,
        mode = "x",
        desc = "Search selection",
      },
      {
        "<leader>sr",
        function()
          require("fzf-lua").resume()
        end,
        desc = "Resume",
      },
      {
        "<leader>sk",
        function()
          require("fzf-lua").keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>sm",
        function()
          require("fzf-lua").marks()
        end,
        desc = "Marks",
      },
      {
        "<leader>sd",
        function()
          require("fzf-lua").diagnostics_document()
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>sD",
        function()
          require("fzf-lua").diagnostics_workspace()
        end,
        desc = "Diagnostics Workspace",
      },
      {
        "<leader>sq",
        function()
          require("fzf-lua").quickfix()
        end,
        desc = "Quickfix",
      },
      {
        "<leader>sl",
        function()
          require("fzf-lua").loclist()
        end,
        desc = "Loclist",
      },
      {
        "<leader>fh",
        function()
          require("fzf-lua").help_tags()
        end,
        desc = "Help",
      },
      {
        "<leader>s/",
        function()
          require("fzf-lua").command_history()
        end,
        desc = "Command History",
      },
      {
        "<leader>st",
        function()
          require("fzf-lua").grep({ search = "\\b(TODO|FIX|FIXME|HACK|NOTE)\\b", no_esc = true })
        end,
        desc = "Todo",
      },
      {
        "<leader>sT",
        function()
          require("fzf-lua").grep({ search = "\\b(TODO|FIX|FIXME)\\b", no_esc = true })
        end,
        desc = "Todo/Fix/Fixme",
      },
      {
        "<leader>gc",
        function()
          require("fzf-lua").git_bcommits()
        end,
        desc = "Buffer Commits",
      },
      {
        "<leader>gC",
        function()
          require("fzf-lua").git_commits()
        end,
        desc = "Commits",
      },
      {
        "<leader>bb",
        function()
          require("fzf-lua").buffers()
        end,
        desc = "List buffers",
      },
      {
        "<leader>uc",
        function()
          require("fzf-lua").colorschemes()
        end,
        desc = "Colorschemes",
      },
      {
        "<leader>fz",
        function()
          require("fzf-lua").zoxide()
        end,
        desc = "Zoxide",
      },
      {
        "<leader>su",
        function()
          require("fzf-lua").undotree()
        end,
        desc = "Undotree",
      },
      {
        "<leader>d/",
        function()
          require("fzf-lua").dap_commands()
        end,
        desc = "DAP Commands",
      },
      {
        "<leader>dR",
        function()
          require("fzf-lua").dap_configurations()
        end,
        desc = "DAP Configurations",
      },
      {
        "<leader>dk",
        function()
          require("fzf-lua").dap_breakpoints()
        end,
        desc = "DAP Breakpoints",
      },
      {
        "<leader>dv",
        function()
          require("fzf-lua").dap_variables()
        end,
        desc = "DAP Variables",
      },
      {
        "<leader>df",
        function()
          require("fzf-lua").dap_frames()
        end,
        desc = "DAP Frames",
      },
    },
    opts = {
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
    },
    config = function(_, opts)
      require("fzf-lua").setup(opts)
      require("fzf-lua").register_ui_select()
    end,
  },
}
