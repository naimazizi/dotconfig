-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
local function map_illuminate(key, dir, buffer)
  vim.keymap.set("n", key, function()
    require("illuminate")["goto_" .. dir .. "_reference"](false)
  end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
end

local function vscodeMappings()
  local vscode = require("vscode")

  -- Delete keymap
  vim.keymap.del("n", "<leader>qq")

  -- Vim Illuminate
  map_illuminate("]]", "next")
  map_illuminate("[[", "prev")

  -- Search text in files
  vim.keymap.set("n", "<leader>/", function()
    vscode.call("leaderkey.ripgrep")
  end, { noremap = true, desc = "search text in files" })

  -- editor
  vim.keymap.set("n", "<leader>cf", function()
    vscode.call("editor.action.formatDocument")
  end, { noremap = true, desc = "Format Text" })

  vim.keymap.set("v", "gc", function()
    vscode.call("editor.action.commentLine")
  end, { noremap = true, desc = "Toggle Comment Line (Visual) -- it mimics ctrl+/" })

  -- Tab Navigation
  vim.keymap.set("n", "<S-l>", function()
    vscode.call("workbench.action.nextEditor")
  end, { noremap = true, desc = "switch between editor to next" })

  vim.keymap.set("n", "<S-h>", function()
    vscode.call("workbench.action.previousEditor")
  end, { noremap = true, desc = "switch between editor to previous" })

  -- LSP
  vim.keymap.set("n", "gr", function()
    vscode.call("editor.action.referenceSearch.trigger")
  end, { noremap = true, desc = "peek references inside vs code" })

  vim.keymap.set("n", "gd", function()
    vscode.call("editor.action.revealDefinition")
  end, { noremap = true, desc = "go to definition inside vs code" })

  vim.keymap.set("n", "gD", function()
    vscode.call("editor.action.revealDeclaration")
  end, { noremap = true, desc = "go to declaration inside vs code" })

  vim.keymap.set("n", "gI", function()
    vscode.call("editor.action.peekImplementation")
  end, { noremap = true, desc = "peek Implementation inside vs code" })

  vim.keymap.set("n", "gy", function()
    vscode.call("editor.action.goToTypeDefinition")
  end, { noremap = true, desc = "go to type definition inside vs code" })

  vim.keymap.set("n", "<leader>sd", function()
    vscode.call("workbench.action.problems.focus")
  end, { noremap = true, desc = "open problems and errors infos" })

  -- Focus window
  vim.keymap.set("n", "<leader>e", function()
    vscode.call("workbench.files.action.focusFilesExplorer")
  end, { noremap = true, desc = "focus to file explorer" })

  vim.keymap.set("n", "<leader>fe", function()
    vscode.call("workbench.files.action.focusFilesExplorer")
  end, { noremap = true, desc = "focus to file explorer" })

  vim.keymap.set("n", "<leader>ff", function()
    vscode.call("leaderkey.findFile")
  end, { noremap = true, desc = "open files" })

  -- Code Action
  vim.keymap.set("n", "<leader>cr", function()
    vscode.call("editor.action.rename")
  end, { noremap = true, desc = "rename symbol" })

  vim.keymap.set("n", "<leader>ca", function()
    vscode.call("editor.action.quickFix")
  end, { noremap = true, desc = "open quick fix in vs code" })

  vim.keymap.set("n", "<leader>cA", function()
    vscode.call("editor.action.sourceAction")
  end, { noremap = true, desc = "open source Action in vs code" })

  vim.keymap.set("n", "<leader>cp", function()
    vscode.call("workbench.panel.markers.view.focus")
  end, { noremap = true, desc = "open problems diagnostics" })

  vim.keymap.set("n", "<leader>cd", function()
    vscode.call("editor.action.marker.next")
  end, { noremap = true, desc = "open problems diagnostics" })

  vim.keymap.set("n", "<leader>co", function()
    vscode.call("editor.action.organizeImports")
  end, { noremap = true, desc = "organize import" })

  vim.keymap.set("n", "<leader>cs", function()
    print("go to symbols in editor")
    vscode.call("outline.focus")
  end, { noremap = true, silent = true, desc = "Focus outline" })

  -- Go to
  vim.keymap.set({ "n", "v" }, "[e", function()
    vscode.call("editor.action.marker.prev")
  end, { noremap = true, desc = "Go to Previous Problem (error, warning, info)" })

  vim.keymap.set({ "n", "v" }, "]e", function()
    vscode.call("editor.action.marker.next")
  end, { noremap = true, desc = "Go to Next Problem (error, warning, info)" })

  vim.keymap.set("n", "[n", function()
    vscode.call("editor.action.wordHighlight.prev")
  end, { noremap = true, desc = "Go to Prev Highlight" })

  vim.keymap.set("n", "]n", function()
    vscode.call("editor.action.wordHighlight.next")
  end, { noremap = true, desc = "Go to Next Highlight" })

  vim.keymap.set("n", "[h", function()
    vscode.call("workbench.action.editor.previousChange")
  end, { noremap = true, desc = "Go to Prev Change" })

  vim.keymap.set("n", "]h", function()
    vscode.call("workbench.action.editor.nextChange")
  end, { noremap = true, desc = "Go to Next Change" })

  -- Harpoon Extension
  vim.keymap.set("n", "<leader>1", function()
    vscode.call("vscode-harpoon.gotoEditor1")
  end, { noremap = true, desc = "Harpoon 1" })

  vim.keymap.set("n", "<leader>2", function()
    vscode.call("vscode-harpoon.gotoEditor2")
  end, { noremap = true, desc = "Harpoon 2" })

  vim.keymap.set("n", "<leader>3", function()
    vscode.call("vscode-harpoon.gotoEditor3")
  end, { noremap = true, desc = "Harpoon 3" })

  vim.keymap.set("n", "<leader>4", function()
    vscode.call("vscode-harpoon.gotoEditor4")
  end, { noremap = true, desc = "Harpoon 4" })

  vim.keymap.set("n", "<leader>h", function()
    vscode.call("vscode-harpoon.editorQuickPick")
  end, { noremap = true, desc = "Harpoon Quick menu" })

  vim.keymap.set("n", "<leader>H", function()
    vscode.call("vscode-harpoon.addEditor")
  end, { noremap = true, desc = "Harpoon Add editor" })

  -- Bookmark Extension
  vim.keymap.set("n", "<leader>sml", function()
    vscode.call("bookmarks.list")
  end, { noremap = true, desc = "open bookmarks list for current files" })

  vim.keymap.set("n", "<leader>smL", function()
    vscode.call("bookmarks.listFromAllFiles")
  end, { noremap = true, desc = "open bookmarks list for all files" })

  vim.keymap.set("n", "<leader>smm", function()
    vscode.call("bookmarks.toggle")
  end, { noremap = true, desc = "toggle bookmarks" })

  vim.keymap.set("n", "<leader>smd", function()
    vscode.call("bookmarks.clear")
  end, { noremap = true, desc = "clear bookmarks from current file" })

  vim.keymap.set("n", "<leader>smr", function()
    vscode.call("bookmarks.clearFromAllFiles")
  end, { noremap = true, desc = "clear bookmarks from all file" })

  -- Jupyter Extension
  vim.keymap.set("n", "<localleader>rr", function()
    vscode.call("jupyter.runcurrentcell")
  end, { noremap = true, desc = "Run Jupyter - current cell" })

  vim.keymap.set("n", "<localleader>ru", function()
    vscode.call("jupyter.runallcellsabove.palette")
  end, { noremap = true, desc = "Run Jupyter - until cursor" })

  vim.keymap.set("n", "<localleader>re", function()
    vscode.call("jupyter.runByLine")
  end, { noremap = true, desc = "Run Jupyter - Send line" })

  vim.keymap.set("n", "<localleader>r<localleader>", function()
    vscode.call("jupyter.interruptkernel")
  end, { noremap = true, desc = "Run Jupyter - interrupt kernel" })

  -- Folding
  vim.keymap.set("n", "zm", function()
    vscode.call("editor.foldAll")
  end, { noremap = true, desc = "Fold all" })

  vim.keymap.set("n", "zR", function()
    vscode.call("editor.unfoldAll")
  end, { noremap = true, desc = "Unfold all" })

  vim.keymap.set("n", "zr", function()
    vscode.call("editor.unfold")
  end, { noremap = true, desc = "Unfold" })

  vim.keymap.set("n", "z1", function()
    vscode.call("editor.foldLevel1")
  end, { noremap = true, desc = "Fold level 1" })

  vim.keymap.set("n", "z2", function()
    vscode.call("editor.foldLevel2")
  end, { noremap = true, desc = "Fold level 2" })

  vim.keymap.set("n", "z3", function()
    vscode.call("editor.foldLevel3")
  end, { noremap = true, desc = "Fold level 3" })

  vim.keymap.set("n", "z4", function()
    vscode.call("editor.foldLevel4")
  end, { noremap = true, desc = "Fold level 4" })

  vim.keymap.set("n", "z`", function()
    vscode.call("editor.foldAllExcept")
  end, { noremap = true, desc = "Fold Except under cursor" })

  vim.keymap.set("n", "zc", function()
    vscode.call("editor.foldAllBlockComments")
  end, { noremap = true, desc = "Fold All Block Comments" })

  vim.keymap.set("n", "za", function()
    vscode.call("editor.foldRecursively")
  end, { noremap = true, desc = "Fold Recursively" })

  vim.keymap.set("n", "zA", function()
    vscode.call("editor.unfoldRecursively")
  end, { noremap = true, desc = "Unfold Recursively" })

  -- Tests
  vim.keymap.set("n", "<leader>td", function()
    vscode.call("testing.debugAtCursor")
  end, { noremap = true, desc = "Debug Nearest Test" })

  vim.keymap.set("n", "<leader>tr", function()
    vscode.call("testing.runAtCursor")
  end, { noremap = true, desc = "Run Nearest Test" })

  vim.keymap.set("n", "<leader>tt", function()
    vscode.call("testing.runCurrentFile")
  end, { noremap = true, desc = "Run Test from current file" })

  vim.keymap.set("n", "<leader>tT", function()
    vscode.call("testing.runAll")
  end, { noremap = true, desc = "Run All Test" })

  vim.keymap.set("n", "<leader>ts", function()
    vscode.call("workbench.view.testing.focus")
  end, { noremap = true, desc = "Show Test Results" })

  -- Source Control
  vim.keymap.set("n", "<leader>gg", function()
    vscode.call("lazygit-vscode.toggle")
  end, { noremap = true, desc = "Show Test Results" })

  -- Debugging
  vim.keymap.set("n", "<leader>dd", function()
    vscode.call("workbench.action.debug.start")
  end, { noremap = true, desc = "Start Debugging" })

  vim.keymap.set("n", "<leader>dt", function()
    vscode.call("workbench.action.debug.stop")
  end, { noremap = true, desc = "Stop Debugging" })

  vim.keymap.set("n", "<leader>dr", function()
    vscode.call("workbench.action.debug.restart")
  end, { noremap = true, desc = "Restart Debugging" })

  vim.keymap.set("n", "<leader>db", function()
    vscode.call("editor.debug.action.toggleBreakpoint")
  end, { noremap = true, desc = "Toggle Breakpoint" })

  vim.keymap.set("n", "<leader>di", function()
    vscode.call("workbench.action.debug.stepInto")
  end, { noremap = true, desc = "Debug - step in" })

  vim.keymap.set("n", "<leader>do", function()
    vscode.call("workbench.action.debug.stepOut")
  end, { noremap = true, desc = "Debug - step out" })

  vim.keymap.set("n", "<leader>dO", function()
    vscode.call("workbench.action.debug.stepOver")
  end, { noremap = true, desc = "Debug - step over" })

  -- Copilot
  vim.keymap.set("n", "<leader>aa", function()
    vscode.call("workbench.action.chat.open")
  end, { noremap = true, desc = "Ask Copilot" })

  vim.keymap.set("n", "<leader>at", function()
    vscode.call("workbench.action.toggleAuxiliaryBar")
  end, { noremap = true, desc = "Toggle Copilot chat" })

  -- Terminal
  vim.keymap.set("n", "<leader>ft", function()
    vscode.call("workbench.action.terminal.toggleTerminal")
  end, { noremap = true, desc = "Toggle Terminal" })

  -- Http Client
  vim.keymap.set("n", "<leader>Rs", function()
    vscode.call("httpyac.send")
  end, { noremap = true, desc = "Send HTTP request" })

  vim.keymap.set("n", "<leader>Ra", function()
    vscode.call("httpyac.sendAll")
  end, { noremap = true, desc = "Send HTTP all requests" })

  vim.keymap.set("n", "<leader>Rr", function()
    vscode.call("httpyac.resend")
  end, { noremap = true, desc = "Replay HTTP requests" })

  vim.keymap.set("n", "<leader>Rc", function()
    vscode.call("httpyac.generateCode")
  end, { noremap = true, desc = "Generate Curl" })

  -- Harpoon
  vim.keymap.set("n", "<leader>h", function()
    vscode.call("vscode-harpoon.editorQuickPick")
  end, { noremap = true, desc = "Harpoon Quick menu" })

  vim.keymap.set("n", "<leader>H", function()
    vscode.call("vscode-harpoon.addEditor")
  end, { noremap = true, desc = "Harpoon Add Editor" })

  vim.keymap.set("n", "<leader>1", function()
    vscode.call("vscode-harpoon.gotoEditor1")
  end, { noremap = true, desc = "Harpoon Go to Editor 1" })

  vim.keymap.set("n", "<leader>2", function()
    vscode.call("vscode-harpoon.gotoEditor2")
  end, { noremap = true, desc = "Harpoon Go to Editor 2" })

  vim.keymap.set("n", "<leader>3", function()
    vscode.call("vscode-harpoon.gotoEditor3")
  end, { noremap = true, desc = "Harpoon Go to Editor 3" })

  vim.keymap.set("n", "<leader>4", function()
    vscode.call("vscode-harpoon.gotoEditor4")
  end, { noremap = true, desc = "Harpoon Go to Editor 4" })

  -- Yazi
  vim.keymap.set("n", "<leader>-", function()
    vscode.call("yazi-vscode.toggle")
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
