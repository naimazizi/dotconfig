if vim.g.vscode then
  return
end

vim.pack.add({
  { src = Config.gh("nvim-neo-tree/neo-tree.nvim"), version = vim.version.range("*") },
  Config.gh("nvim-lua/plenary.nvim"),
  Config.gh("MunifTanjim/nui.nvim"),
  Config.gh("antosha417/nvim-lsp-file-operations"),
})

Config.now(function()
  require("neo-tree").setup({
    sources = { "filesystem" },
    open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline", "edgy" },
    filesystem = {
      bind_to_cwd = true,
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
    },
    window = {
      wrap = true,
      mappings = {
        ["l"] = "open",
        ["h"] = "close_node",
        ["<space>"] = "none",
        ["Y"] = function(state)
          local node = state.tree:get_node()
          if not node or not node.id then
            vim.notify("No node selected.", vim.log.levels.WARN)
            return
          end

          if vim.fn.has("clipboard") == 0 then
            vim.notify("System clipboard is not available.", vim.log.levels.ERROR)
            return
          end

          local filepath = node:get_id()
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
        end,
        ["O"] = {
          function(state)
            vim.ui.open(state.tree:get_node().path)
          end,
          desc = "Open with System Application",
        },
        ["P"] = { "toggle_preview", config = { use_float = false } },
      },
    },
    default_component_configs = {
      indent = {
        with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },
      git_status = {
        symbols = {
          unstaged = "󰄱",
          staged = "󰱒",
        },
      },
    },
  })

  require("lsp-file-operations").setup()

  vim.keymap.set("n", "<leader>e", function()
    require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
  end, { desc = "Explorer NeoTree (Root Dir)" })

  vim.api.nvim_create_autocmd("VimLeavePre", {
    once = true,
    callback = function()
      pcall(function()
        vim.cmd("Neotree close")
      end)
    end,
  })
end)
