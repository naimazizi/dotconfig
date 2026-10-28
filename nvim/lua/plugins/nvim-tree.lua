if vim.g.vscode then
  return
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.pack.add({
  Config.gh("nvim-tree/nvim-tree.lua"),
  Config.gh("antosha417/nvim-lsp-file-operations"),
})

Config.now(function()
  local api = require("nvim-tree.api")
  require("nvim-tree").setup({
    view = { width = 45 },
    sync_root_with_cwd = true,
    update_focused_file = { enable = true },
    filesystem_watchers = { enable = true },
    actions = {
      open_file = {
        window_picker = {
          exclude = {
            filetype = { "terminal", "Trouble", "trouble", "qf", "Outline", "edgy" },
            buftype = { "nofile", "terminal", "help" },
          },
        },
      },
    },
    on_attach = function(bufnr)
      vim.b[bufnr].miniindentscope_disable = true
      vim.b[bufnr].minicursorword_disable = true
      api.map.on_attach.default(bufnr)
      local function opts(desc)
        return { buffer = bufnr, desc = "nvim-tree: " .. desc, silent = true, nowait = true }
      end
      vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
      vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close directory"))
      vim.keymap.set("n", "<Space>", "<Nop>", opts("Disabled"))
      vim.keymap.set("n", "Y", function()
        local node = api.tree.get_node_under_cursor()
        if not node or not node.absolute_path then
          vim.notify("No node selected.", vim.log.levels.WARN)
          return
        end

        if vim.fn.has("clipboard") == 0 then
          vim.notify("System clipboard is not available.", vim.log.levels.ERROR)
          return
        end

        local filepath = node.absolute_path
        local filename = node.name
        local modify = vim.fn.fnamemodify

        local choices = {
          { label = "Absolute path", value = filepath },
          { label = "Path relative to CWD", value = modify(filepath, ":.") },
          { label = "Path relative to HOME", value = modify(filepath, ":~") },
          { label = "Filename", value = filename },
          { label = "Filename without extension", value = modify(filename, ":r") },
          { label = "Extension of the filename", value = modify(filename, ":e") },
        }

        vim.ui.select(choices, {
          prompt = "Choose to copy to clipboard:",
          format_item = function(item)
            return string.format("%-30s %s", item.label, item.value)
          end,
        }, function(choice)
          if not choice then
            vim.notify("Copy cancelled.", vim.log.levels.INFO)
            return
          end

          local value_to_copy = choice.value

          vim.fn.setreg("+", value_to_copy)
          vim.notify("Copied to clipboard: " .. value_to_copy)
        end)
      end, opts("Copy path"))
      vim.keymap.set("n", "O", api.node.run.system, opts("Open with System Application"))
      vim.keymap.set("n", "P", api.node.open.preview, opts("Open preview"))
    end,
    renderer = {
      indent_width = 1,
      icons = {
        show = {
          hidden = true,
        },
        git_placement = "after",
        bookmarks_placement = "after",
        symlink_arrow = " -> ",
        glyphs = {
          bookmark = "",
          modified = "",
          hidden = "󱙝",
          git = {
            unstaged = "×",
            staged = "",
            unmerged = "󰧾",
            untracked = "",
            renamed = "",
            deleted = "",
            ignored = "∅",
          },
        },
      },
    },
  })

  require("lsp-file-operations").setup()

  Config.tree_tabline = function()
    local tabline = require("mini.tabline").make_tabline_string()
    local win = api.tree.winid()
    if not win or not vim.api.nvim_win_is_valid(win) then
      return tabline
    end
    if vim.api.nvim_win_get_config(win).relative ~= "" or vim.api.nvim_win_get_position(win)[2] ~= 0 then
      return tabline
    end
    local width = vim.api.nvim_win_get_width(win) + 1
    local label = ("  Explorer "):sub(1, width)
    return "%#MiniTablineFill#" .. label .. string.rep(" ", width - #label) .. tabline
  end
  vim.o.tabline = "%!v:lua.Config.tree_tabline()"

  for _, event in ipairs({ api.events.Event.TreeOpen, api.events.Event.TreeClose, api.events.Event.Resize }) do
    api.events.subscribe(event, function()
      vim.schedule(function()
        vim.cmd.redrawtabline()
      end)
    end)
  end

  vim.keymap.set("n", "<leader>e", function()
    api.tree.toggle({ path = vim.uv.cwd(), find_file = true })
  end, { desc = "Explorer NvimTree (Root Dir)" })
end)
