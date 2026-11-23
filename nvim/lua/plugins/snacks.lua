if vim.g.vscode then
  return
end

vim.pack.add({ Config.gh("folke/snacks.nvim") })

Config.now(function()
  require("snacks").setup({
    image = { enabled = true },
    bigfile = { enabled = true },
    bufdelete = { enabled = true },
    explorer = { enabled = true },
    picker = {
      enabled = true,
      ui_select = false,
      sources = {
        explorer = {
          layout = { layout = { width = 45 } },
          actions = {
            copy_path = function(_, item)
              if not item or not item.file then
                vim.notify("No node selected.", vim.log.levels.WARN)
                return
              end
              if vim.fn.has("clipboard") == 0 then
                vim.notify("System clipboard is not available.", vim.log.levels.ERROR)
                return
              end

              local filepath = item.file
              local modify = vim.fn.fnamemodify
              local filename = modify(filepath, ":t")
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
                format_item = function(choice)
                  return string.format("%-30s %s", choice.label, choice.value)
                end,
              }, function(choice)
                if not choice then
                  vim.notify("Copy cancelled.", vim.log.levels.INFO)
                  return
                end
                vim.fn.setreg("+", choice.value)
                vim.notify("Copied to clipboard: " .. choice.value)
              end)
            end,
          },
          win = { list = { keys = { ["Y"] = { "copy_path", desc = "Copy path" } } } },
        },
      },
    },
    indent = {
      enabled = true,
      indent = { char = "┊" },
      scope = { only_current = true },
      chunk = {
        enabled = true,
        only_current = true,
        char = { corner_top = "╭", corner_bottom = "╰" },
      },
    },
    quickfile = { enabled = true },
    rename = { enabled = true },
    gitbrowse = { enabled = true },
    scope = { enabled = true },
    scratch = { enabled = true },
    scroll = { enabled = true },
    terminal = { enabled = true },
    zen = {
      enabled = true,
      toggles = {
        dim = true,
        git_signs = true,
        mini_diff_signs = true,
        diagnostics = true,
        inlay_hints = true,
      },
    },
  })

  local map = vim.keymap.set
  map("n", "<leader>e", function()
    Snacks.explorer({ cwd = vim.uv.cwd() })
  end, { desc = "Toggle Explorer" })
  map("n", "<leader>bd", function()
    Snacks.bufdelete()
  end, { desc = "Buffer Delete" })
  map("n", "<leader>bo", function()
    Snacks.bufdelete.other()
  end, { desc = "Buffer Delete Others" })
  map("n", "<leader>uz", function()
    Snacks.zen()
  end, { desc = "Toggle zen mode" })
  map("n", "<leader>cR", function()
    Snacks.rename.rename_file()
  end, { desc = "Rename file" })
  map({ "n", "x" }, "<leader>gB", function()
    Snacks.gitbrowse()
  end, { desc = "Git Browse" })
  map("n", "<leader>.", function()
    Snacks.scratch()
  end, { desc = "Toggle scratch buffer" })
  map("n", "<leader>bs", function()
    vim.ui.select(Snacks.scratch.list(), {
      prompt = "Select scratch buffer",
      format_item = function(item)
        return table.concat({ item.name, item.ft, item.cwd or "", item.branch or "", item.file }, " ")
      end,
    }, function(item)
      if item then
        Snacks.scratch({ file = item.file } --[[@as snacks.scratch.Config]])
      end
    end)
  end, { desc = "Select scratch buffer" })
end)
