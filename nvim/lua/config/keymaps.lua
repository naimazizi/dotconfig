-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

local function callVSCodeFunction(vsCodeCommand)
  vim.cmd(vsCodeCommand)
end

local function map_illuminate(key, dir, buffer)
  vim.keymap.set("n", key, function()
    require("illuminate")["goto_" .. dir .. "_reference"](false)
  end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
end

local function vscodeMappings()
  -- Vim Illuminate
  map_illuminate("]]", "next")
  map_illuminate("[[", "prev")
  vim.api.nvim_create_autocmd("FileType", {
    callback = function()
      local buffer = vim.api.nvim_get_current_buf()
      map_illuminate("]]", "next", buffer)
      map_illuminate("[[", "prev", buffer)
    end,
  })

  -- Tab Navigation
  map("n", "<S-l>", function()
    callVSCodeFunction("call VSCodeNotify('workbench.action.nextEditor')")
  end, { noremap = true, desc = "switch between editor to next" })

  map("n", "<S-h>", function()
    callVSCodeFunction("call VSCodeNotify('workbench.action.previousEditor')")
  end, { noremap = true, desc = "switch between editor to previous" })

  -- LSP
  map("n", "gr", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.referenceSearch.trigger')")
  end, { noremap = true, desc = "peek references inside vs code" })

  map("n", "gd", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.revealDefinition')")
  end, { noremap = true, desc = "go to definition inside vs code" })

  map("n", "gD", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.revealDeclaration')")
  end, { noremap = true, desc = "go to declaration inside vs code" })

  map("n", "gI", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.peekImplementation')")
  end, { noremap = true, desc = "peek Implementation inside vs code" })

  map("n", "gy", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.goToTypeDefinition')")
  end, { noremap = true, desc = "go to type definition inside vs code" })

  map("n", "<leader>sd", function()
    callVSCodeFunction("call VSCodeNotify('workbench.action.problems.focus')")
  end, { noremap = true, desc = "open problems and errors infos" })

  -- Focus window
  map("n", "<leader>e", function()
    callVSCodeFunction("call VSCodeNotify('workbench.files.action.focusFilesExplorer')")
  end, { noremap = true, desc = "focus to file explorer" })

  map("n", "<leader>fe", function()
    callVSCodeFunction("call VSCodeNotify('workbench.files.action.focusFilesExplorer')")
  end, { noremap = true, desc = "focus to file explorer" })

  map("n", "<leader>ff", function()
    callVSCodeFunction("call VSCodeNotify('workbench.action.quickOpen')")
  end, { noremap = true, desc = "open files" })

  map("n", "<leader>gg", function()
    callVSCodeFunction("call VSCodeNotify('workbench.view.scm')")
  end, { noremap = true, desc = "open git source control" })

  -- Code Action
  map("n", "<leader>cr", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.rename')")
  end, { noremap = true, desc = "rename symbol" })

  map("n", "<leader>ca", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.quickFix')")
  end, { noremap = true, desc = "open quick fix in vs code" })

  map("n", "<leader>cA", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.sourceAction')")
  end, { noremap = true, desc = "open source Action in vs code" })

  map("n", "<leader>cp", function()
    callVSCodeFunction("call VSCodeNotify('workbench.panel.markers.view.focus')")
  end, { noremap = true, desc = "open problems diagnostics" })

  map("n", "<leader>cd", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.marker.next')")
  end, { noremap = true, desc = "open problems diagnostics" })

  map("n", "<leader>co", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.organizeImports')")
  end, { noremap = true, desc = "organize import" })

  map("n", "<leader>cs", function()
    print("go to symbols in editor")
    callVSCodeFunction("call VSCodeCall('workbench.action.gotoSymbol')")
  end, { noremap = true, silent = true, desc = "go to symbols in editor" })

  -- Multi-cursor mappings
  map({ "n", "x", "i" }, "<C-d>", function()
    require("vscode-multi-cursor").addSelectionToNextFindMatch()
  end)

  -- Go to
  map({ "n", "v" }, "[e", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.marker.prev')")
  end, { noremap = true, desc = "Go to Previous Problem (error, warning, info)" })

  map({ "n", "v" }, "]e", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.marker.next')")
  end, { noremap = true, desc = "Go to Next Problem (error, warning, info)" })

  map("n", "[n", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.wordHighlight.prev')")
  end, { noremap = true, desc = "Go to Prev Highlight" })

  map("n", "]n", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.wordHighlight.next')")
  end, { noremap = true, desc = "Go to Next Highlight" })

  map("n", "[h", function()
    callVSCodeFunction("call VSCodeNotify('workbench.action.editor.previousChange')")
  end, { noremap = true, desc = "Go to Prev Change" })

  map("n", "]h", function()
    callVSCodeFunction("call VSCodeNotify('workbench.action.editor.nextChange')")
  end, { noremap = true, desc = "Go to Next Change" })

  -- Harpoon Extension
  map("n", "<leader>1", function()
    callVSCodeFunction("call VSCodeNotify('vscode-harpoon.gotoEditor1')")
  end, { noremap = true, desc = "Harpoon 1" })

  map("n", "<leader>2", function()
    callVSCodeFunction("call VSCodeNotify('vscode-harpoon.gotoEditor2')")
  end, { noremap = true, desc = "Harpoon 2" })

  map("n", "<leader>3", function()
    callVSCodeFunction("call VSCodeNotify('vscode-harpoon.gotoEditor3')")
  end, { noremap = true, desc = "Harpoon 3" })

  map("n", "<leader>4", function()
    callVSCodeFunction("call VSCodeNotify('vscode-harpoon.gotoEditor4')")
  end, { noremap = true, desc = "Harpoon 4" })

  map("n", "<leader>h", function()
    callVSCodeFunction("call VSCodeNotify('vscode-harpoon.editorQuickPick')")
  end, { noremap = true, desc = "Harpoon Quick menu" })

  map("n", "<leader>H", function()
    callVSCodeFunction("call VSCodeNotify('vscode-harpoon.addEditor')")
  end, { noremap = true, desc = "Harpoon Add editor" })

  -- Bookmark Extension
  map("n", "<leader>sml", function()
    callVSCodeFunction("call VSCodeNotify('bookmarks.list')")
  end, { noremap = true, desc = "open bookmarks list for current files" })

  map("n", "<leader>smL", function()
    callVSCodeFunction("call VSCodeNotify('bookmarks.listFromAllFiles')")
  end, { noremap = true, desc = "open bookmarks list for all files" })

  map("n", "<leader>smm", function()
    callVSCodeFunction("call VSCodeNotify('bookmarks.toggle')")
  end, { noremap = true, desc = "toggle bookmarks" })

  map("n", "<leader>smd", function()
    callVSCodeFunction("call VSCodeNotify('bookmarks.clear')")
  end, { noremap = true, desc = "clear bookmarks from current file" })

  map("n", "<leader>smr", function()
    callVSCodeFunction("call VSCodeNotify('bookmarks.clearFromAllFiles')")
  end, { noremap = true, desc = "clear bookmarks from all file" })

  -- Jupyter Extension
  map("n", "<localleader>rr", function()
    callVSCodeFunction("call VSCodeNotify('jupyter.runcurrentcell')")
  end, { noremap = true, desc = "Run Jupyter - current cell" })

  map("n", "<localleader>ru", function()
    callVSCodeFunction("call VSCodeNotify('jupyter.runallcellsabove.palette')")
  end, { noremap = true, desc = "Run Jupyter - until cursor" })

  map("n", "<localleader>re", function()
    callVSCodeFunction("call VSCodeNotify('jupyter.runByLine')")
  end, { noremap = true, desc = "Run Jupyter - Send line" })

  map("n", "<localleader>r<localleader>", function()
    callVSCodeFunction("call VSCodeNotify('jupyter.interruptkernel')")
  end, { noremap = true, desc = "Run Jupyter - interrupt kernel" })

  -- Folding
  map("n", "zm", function()
    callVSCodeFunction("call VSCodeNotify('editor.foldAll')")
  end, { noremap = true, desc = "Fold all" })

  map("n", "zR", function()
    callVSCodeFunction("call VSCodeNotify('editor.unfoldAll')")
  end, { noremap = true, desc = "Unfold all" })

  map("n", "zr", function()
    callVSCodeFunction("call VSCodeNotify('editor.unfold')")
  end, { noremap = true, desc = "Unfold" })

  map("n", "z1", function()
    callVSCodeFunction("call VSCodeNotify('editor.foldLevel1')")
  end, { noremap = true, desc = "Fold level 1" })

  map("n", "z2", function()
    callVSCodeFunction("call VSCodeNotify('editor.foldLevel2')")
  end, { noremap = true, desc = "Fold level 2" })

  map("n", "z3", function()
    callVSCodeFunction("call VSCodeNotify('editor.foldLevel3')")
  end, { noremap = true, desc = "Fold level 3" })

  map("n", "z4", function()
    callVSCodeFunction("call VSCodeNotify('editor.foldLevel4')")
  end, { noremap = true, desc = "Fold level 4" })

  map("n", "z`", function()
    callVSCodeFunction("call VSCodeNotify('editor.foldAllExcept')")
  end, { noremap = true, desc = "Fold Except under cursor" })

  map("n", "zc", function()
    callVSCodeFunction("call VSCodeNotify('editor.foldAllBlockComments')")
  end, { noremap = true, desc = "Fold All Block Comments" })

  map("n", "za", function()
    callVSCodeFunction("call VSCodeNotify('editor.foldRecursively')")
  end, { noremap = true, desc = "Fold Recursively" })

  map("n", "zA", function()
    callVSCodeFunction("call VSCodeNotify('editor.unfoldRecursively')")
  end, { noremap = true, desc = "Unfold Recursively" })

  -- Delete keymap
  vim.keymap.del("n", "<leader>qq")
end

if vim.g.vscode then
  print("⚡connected to NEOVIM")
  vscodeMappings()
else
  -- Clear search and stop snippet on escape
  vim.keymap.set({ "i", "n", "s" }, "<esc>", function()
    if not require("copilot-lsp.nes").clear() then
      vim.cmd("noh")
      LazyVim.cmp.actions.snippet_stop()
    end
    return "<esc>"
  end, { expr = true, desc = "Escape and Clear hlsearch" })
end
