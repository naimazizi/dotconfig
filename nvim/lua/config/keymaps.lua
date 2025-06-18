-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any     additional keymaps here
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
  -- Delete keymap
  vim.keymap.del("n", "<leader>qq")

  -- Vim Illuminate
  map_illuminate("]]", "next")
  map_illuminate("[[", "prev")

  -- Search text in files
  map("n", "<leader>/", function()
    callVSCodeFunction("call VSCodeNotify('leaderkey.ripgrep')")
  end, { noremap = true, desc = "search text in files" })

  -- editor
  map("n", "<leader>cf", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.formatDocument')")
  end, { noremap = true, desc = "Format Text" })

  map("v", "gc", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.commentLine')")
  end, { noremap = true, desc = "Toggle Comment Line (Visual) -- it mimics ctrl+/" })

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
    callVSCodeFunction("call VSCodeNotify('leaderkey.findFile')")
  end, { noremap = true, desc = "open files" })

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
    callVSCodeFunction("call VSCodeCall('outline.focus')")
  end, { noremap = true, silent = true, desc = "Focus outline" })

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

  -- Tests
  map("n", "<leader>td", function()
    callVSCodeFunction("call VSCodeNotify('testing.debugAtCursor')")
  end, { noremap = true, desc = "Debug Nearest Test" })

  map("n", "<leader>tr", function()
    callVSCodeFunction("call VSCodeNotify('testing.runAtCursor')")
  end, { noremap = true, desc = "Run Nearest Test" })

  map("n", "<leader>tt", function()
    callVSCodeFunction("call VSCodeNotify('testing.runCurrentFile')")
  end, { noremap = true, desc = "Run Test from current file" })

  map("n", "<leader>tT", function()
    callVSCodeFunction("call VSCodeNotify('testing.runAll')")
  end, { noremap = true, desc = "Run All Test" })

  map("n", "<leader>ts", function()
    callVSCodeFunction("call VSCodeNotify('workbench.view.testing.focus')")
  end, { noremap = true, desc = "Show Test Results" })

  -- Source Control
  map("n", "<leader>gg", function()
    callVSCodeFunction("call VSCodeNotify('lazygit-vscode.toggle')")
  end, { noremap = true, desc = "Show Test Results" })

  -- Debugging
  map("n", "<leader>dd", function()
    callVSCodeFunction("call VSCodeNotify('workbench.view.debug')")
  end, { noremap = true, desc = "Start Debugging" })

  map("n", "<leader>db", function()
    callVSCodeFunction("call VSCodeNotify('editor.debug.action.toggleBreakpoint')")
  end, { noremap = true, desc = "Toggle Breakpoint" })

  -- Copilot
  map("n", "<leader>aa", function()
    callVSCodeFunction("call VSCodeNotify('workbench.action.chat.open')")
  end, { noremap = true, desc = "Ask Copilot" })

  map("n", "<leader>at", function()
    callVSCodeFunction("call VSCodeNotify('workbench.action.toggleAuxiliaryBar')")
  end, { noremap = true, desc = "Toggle Copilot chat" })

  -- Terminal
  map("n", "<leader>ft", function()
    callVSCodeFunction("call VSCodeNotify('workbench.action.terminal.toggleTerminal')")
  end, { noremap = true, desc = "Toggle Terminal" })

  -- Http Client
  map("n", "<leader>Rs", function()
    callVSCodeFunction("call VSCodeNotify('httpyac.send')")
  end, { noremap = true, desc = "Send HTTP request" })

  map("n", "<leader>Ra", function()
    callVSCodeFunction("call VSCodeNotify('httpyac.sendAll')")
  end, { noremap = true, desc = "Send HTTP all requests" })

  map("n", "<leader>Rr", function()
    callVSCodeFunction("call VSCodeNotify('httpyac.resend')")
  end, { noremap = true, desc = "Replay HTTP requests" })

  map("n", "<leader>Rc", function()
    callVSCodeFunction("call VSCodeNotify('httpyac.generateCode')")
  end, { noremap = true, desc = "Generate Curl" })

  -- Harpoon
  map("n", "<leader>h", function()
    callVSCodeFunction("call VSCodeNotify('vscode-harpoon.editorQuickPick')")
  end, { noremap = true, desc = "Harpoon Quick menu" })

  map("n", "<leader>H", function()
    callVSCodeFunction("call VSCodeNotify('vscode-harpoon.addEditor')")
  end, { noremap = true, desc = "Harpoon Add Editor" })

  map("n", "<leader>1", function()
    callVSCodeFunction("call VSCodeNotify('vscode-harpoon.gotoEditor1')")
  end, { noremap = true, desc = "Harpoon Go to Editor 1" })

  map("n", "<leader>2", function()
    callVSCodeFunction("call VSCodeNotify('vscode-harpoon.gotoEditor2')")
  end, { noremap = true, desc = "Harpoon Go to Editor 2" })

  map("n", "<leader>3", function()
    callVSCodeFunction("call VSCodeNotify('vscode-harpoon.gotoEditor3')")
  end, { noremap = true, desc = "Harpoon Go to Editor 3" })

  map("n", "<leader>4", function()
    callVSCodeFunction("call VSCodeNotify('vscode-harpoon.gotoEditor4')")
  end, { noremap = true, desc = "Harpoon Go to Editor 4" })

  -- Yazi
  map("n", "<leader>-", function()
    callVSCodeFunction("call VSCodeNotify('yazi-vscode.toggle')")
  end, { noremap = true, desc = "Toggle Yazi" })
end

if vim.g.vscode then
  print(
    "⚡ NEOVIM "
      .. vim.version().major
      .. "."
      .. vim.version().minor
      .. "."
      .. vim.version().patch
      .. " - "
      .. vim.version().prerelease
      .. " - "
      .. vim.version().build
  )
  vscodeMappings()
elseif vim.g.neovide then
  vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
  vim.keymap.set("v", "<D-c>", '"+y') -- Copy
  vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
  vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
  vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
  vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode
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
