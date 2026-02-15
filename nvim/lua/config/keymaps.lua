local map = vim.keymap.set

-- LazyVim-ish
map("n", "<Esc>", "<cmd>nohlsearch<cr><Esc>", { silent = true, desc = "Clear hlsearch" })

-- Terminal escape
map("t", "<Esc>", "<C-\\><C-n>", { silent = true, desc = "Exit terminal mode" })

-- Neovim general keymaps
if not vim.g.vscode then
  -- Sessions / quit (LazyVim-ish)
  map("n", "<leader>qq", "<cmd>qa<cr>", { silent = true, desc = "Quit all" })

  -- New buffer
  map("n", "<leader>bn", "<cmd>enew<cr>", { silent = true, desc = "New buffer" })

  -- LazyVim-ish LSP/diagnostics mappings
  map("n", "<leader>cd", vim.diagnostic.open_float, { silent = true, desc = "Line diagnostics" })
  map("n", "<leader>cl", "<cmd>LspInfo<cr>", { silent = true, desc = "Lsp Info" })

  -- Quickfix / location list (LazyVim-ish)
  map("n", "[l", "<cmd>lprev<cr>", { silent = true, desc = "Prev location" })
  map("n", "]l", "<cmd>lnext<cr>", { silent = true, desc = "Next location" })

  -- Split window
  map("n", "<leader>-", "<cmd>split<cr>", { noremap = true, desc = "Split window below" })
  map("n", "<leader>|", "<cmd>vsplit<cr>", { noremap = true, desc = "Split window right" })

  -- Delete LSP keymaps
  for _, key in ipairs({ "gra", "gri", "grn", "grr", "grt" }) do
    pcall(vim.keymap.del, "n", key)
  end
end

-- Neovide specific keymap
if vim.g.neovide then
  map("n", "<D-s>", ":w<CR>") -- Save
  map("v", "<D-c>", '"+y') -- Copy
  map("n", "<D-v>", '"+P') -- Paste normal mode
  map("v", "<D-v>", '"+P') -- Paste visual mode
  map("c", "<D-v>", "<C-R>+") -- Paste command mode
  map("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode
end

-- VScode specific keymap
if vim.g.vscode then
  local vscode = require("vscode")

  -- VSCode-specific keymaps for search and navigation
  map("n", "<leader><space>", "<cmd>Find<cr>")
  map("n", "<leader>ss", function()
    vscode.call("workbench.action.gotoSymbol")
  end)

  -- Toggle VS Code integrated terminal
  for _, lhs in ipairs({ "<leader>ft", "<leader>fT", "<c-/>" }) do
    map("n", lhs, function()
      vscode.call("workbench.action.terminal.toggleTerminal")
    end)
  end

  -- Search text in files
  map("n", "<leader>/", function()
    vscode.call("leaderkey.ripgrep")
  end, { noremap = true, desc = "search text in files" })

  -- editor
  map("n", "<leader>cf", function()
    vscode.call("editor.action.formatDocument")
  end, { noremap = true, desc = "Format Text" })

  map("v", "gc", function()
    vscode.call("editor.action.commentLine")
  end, { noremap = true, desc = "Toggle Comment Line (Visual) -- it mimics ctrl+/" })

  -- Tab Navigation
  map("n", "<S-l>", function()
    vscode.call("workbench.action.nextEditor")
  end, { noremap = true, desc = "switch between editor to next" })

  map("n", "<S-h>", function()
    vscode.call("workbench.action.previousEditor")
  end, { noremap = true, desc = "switch between editor to previous" })

  -- LSP
  map("n", "gr", function()
    vscode.call("editor.action.referenceSearch.trigger")
  end, { noremap = true, desc = "peek references inside vs code" })

  map("n", "gd", function()
    vscode.call("editor.action.revealDefinition")
  end, { noremap = true, desc = "go to definition inside vs code" })

  map("n", "gD", function()
    vscode.call("editor.action.revealDeclaration")
  end, { noremap = true, desc = "go to declaration inside vs code" })

  map("n", "gI", function()
    vscode.call("editor.action.peekImplementation")
  end, { noremap = true, desc = "peek Implementation inside vs code" })

  map("n", "gy", function()
    vscode.call("editor.action.goToTypeDefinition")
  end, { noremap = true, desc = "go to type definition inside vs code" })

  map("n", "<leader>sd", function()
    vscode.call("workbench.action.problems.focus")
  end, { noremap = true, desc = "open problems and errors infos" })

  -- Focus window
  map("n", "<leader>e", function()
    vscode.call("workbench.files.action.focusFilesExplorer")
  end, { noremap = true, desc = "focus to file explorer" })

  map("n", "<leader>fe", function()
    vscode.call("workbench.files.action.focusFilesExplorer")
  end, { noremap = true, desc = "focus to file explorer" })

  map("n", "<leader>ff", function()
    vscode.call("leaderkey.findFile")
  end, { noremap = true, desc = "open files" })

  -- Code Action
  map("n", "<leader>cr", function()
    vscode.call("editor.action.rename")
  end, { noremap = true, desc = "rename symbol" })

  map("n", "<leader>ca", function()
    vscode.call("editor.action.quickFix")
  end, { noremap = true, desc = "open quick fix in vs code" })

  map("n", "<leader>cA", function()
    vscode.call("editor.action.sourceAction")
  end, { noremap = true, desc = "open source Action in vs code" })

  map("n", "<leader>cp", function()
    vscode.call("workbench.panel.markers.view.focus")
  end, { noremap = true, desc = "open problems diagnostics" })

  map("n", "<leader>cd", function()
    vscode.call("editor.action.marker.next")
  end, { noremap = true, desc = "open problems diagnostics" })

  map("n", "<leader>co", function()
    vscode.call("editor.action.organizeImports")
  end, { noremap = true, desc = "organize import" })

  map("n", "<leader>cs", function()
    print("go to symbols in editor")
    vscode.call("outline.focus")
  end, { noremap = true, silent = true, desc = "Focus outline" })

  -- Go to
  map({ "n", "v" }, "[e", function()
    vscode.call("editor.action.marker.prev")
  end, { noremap = true, desc = "Go to Previous Problem (error, warning, info)" })

  map({ "n", "v" }, "]e", function()
    vscode.call("editor.action.marker.next")
  end, { noremap = true, desc = "Go to Next Problem (error, warning, info)" })

  map("n", "[n", function()
    vscode.call("editor.action.wordHighlight.prev")
  end, { noremap = true, desc = "Go to Prev Highlight" })

  map("n", "]n", function()
    vscode.call("editor.action.wordHighlight.next")
  end, { noremap = true, desc = "Go to Next Highlight" })

  map("n", "[h", function()
    vscode.call("workbench.action.editor.previousChange")
  end, { noremap = true, desc = "Go to Prev Change" })

  map("n", "]h", function()
    vscode.call("workbench.action.editor.nextChange")
  end, { noremap = true, desc = "Go to Next Change" })

  -- Harpoon Extension
  map("n", "<leader>1", function()
    vscode.call("vscode-harpoon.gotoEditor1")
  end, { noremap = true, desc = "Harpoon 1" })

  map("n", "<leader>2", function()
    vscode.call("vscode-harpoon.gotoEditor2")
  end, { noremap = true, desc = "Harpoon 2" })

  map("n", "<leader>3", function()
    vscode.call("vscode-harpoon.gotoEditor3")
  end, { noremap = true, desc = "Harpoon 3" })

  map("n", "<leader>4", function()
    vscode.call("vscode-harpoon.gotoEditor4")
  end, { noremap = true, desc = "Harpoon 4" })

  map("n", "<leader>h", function()
    vscode.call("vscode-harpoon.editorQuickPick")
  end, { noremap = true, desc = "Harpoon Quick menu" })

  map("n", "<leader>H", function()
    vscode.call("vscode-harpoon.addEditor")
  end, { noremap = true, desc = "Harpoon Add editor" })

  -- Bookmark Extension
  map("n", "<leader>sml", function()
    vscode.call("bookmarks.list")
  end, { noremap = true, desc = "open bookmarks list for current files" })

  map("n", "<leader>smL", function()
    vscode.call("bookmarks.listFromAllFiles")
  end, { noremap = true, desc = "open bookmarks list for all files" })

  map("n", "<leader>smm", function()
    vscode.call("bookmarks.toggle")
  end, { noremap = true, desc = "toggle bookmarks" })

  map("n", "<leader>smd", function()
    vscode.call("bookmarks.clear")
  end, { noremap = true, desc = "clear bookmarks from current file" })

  map("n", "<leader>smr", function()
    vscode.call("bookmarks.clearFromAllFiles")
  end, { noremap = true, desc = "clear bookmarks from all file" })

  -- Jupyter Extension
  map("n", "<localleader>rr", function()
    vscode.call("jupyter.runcurrentcell")
  end, { noremap = true, desc = "Run Jupyter - current cell" })

  map("n", "<localleader>ru", function()
    vscode.call("jupyter.runallcellsabove.palette")
  end, { noremap = true, desc = "Run Jupyter - until cursor" })

  map("n", "<localleader>re", function()
    vscode.call("jupyter.execSelectionInteractive")
  end, { noremap = true, desc = "Run Jupyter - Send line" })

  map("n", "<localleader>r<localleader>", function()
    vscode.call("jupyter.interruptkernel")
  end, { noremap = true, desc = "Run Jupyter - interrupt kernel" })

  -- Folding
  map("n", "zm", function()
    vscode.call("editor.foldAll")
  end, { noremap = true, desc = "Fold all" })

  map("n", "zR", function()
    vscode.call("editor.unfoldAll")
  end, { noremap = true, desc = "Unfold all" })

  map("n", "zr", function()
    vscode.call("editor.unfold")
  end, { noremap = true, desc = "Unfold" })

  map("n", "z1", function()
    vscode.call("editor.foldLevel1")
  end, { noremap = true, desc = "Fold level 1" })

  map("n", "z2", function()
    vscode.call("editor.foldLevel2")
  end, { noremap = true, desc = "Fold level 2" })

  map("n", "z3", function()
    vscode.call("editor.foldLevel3")
  end, { noremap = true, desc = "Fold level 3" })

  map("n", "z4", function()
    vscode.call("editor.foldLevel4")
  end, { noremap = true, desc = "Fold level 4" })

  map("n", "z`", function()
    vscode.call("editor.foldAllExcept")
  end, { noremap = true, desc = "Fold Except under cursor" })

  map("n", "zc", function()
    vscode.call("editor.foldAllBlockComments")
  end, { noremap = true, desc = "Fold All Block Comments" })

  map("n", "za", function()
    vscode.call("editor.foldRecursively")
  end, { noremap = true, desc = "Fold Recursively" })

  map("n", "zA", function()
    vscode.call("editor.unfoldRecursively")
  end, { noremap = true, desc = "Unfold Recursively" })

  -- Tests
  map("n", "<leader>td", function()
    vscode.call("testing.debugAtCursor")
  end, { noremap = true, desc = "Debug Nearest Test" })

  map("n", "<leader>tr", function()
    vscode.call("testing.runAtCursor")
  end, { noremap = true, desc = "Run Nearest Test" })

  map("n", "<leader>tt", function()
    vscode.call("testing.runCurrentFile")
  end, { noremap = true, desc = "Run Test from current file" })

  map("n", "<leader>tT", function()
    vscode.call("testing.runAll")
  end, { noremap = true, desc = "Run All Test" })

  map("n", "<leader>ts", function()
    vscode.call("workbench.view.testing.focus")
  end, { noremap = true, desc = "Show Test Results" })

  -- Source Control
  map("n", "<leader>gg", function()
    vscode.call("lazygit-vscode.toggle")
  end, { noremap = true, desc = "Show Test Results" })

  -- Debugging
  map("n", "<leader>dd", function()
    vscode.call("workbench.action.debug.start")
  end, { noremap = true, desc = "Start Debugging" })

  map("n", "<leader>dt", function()
    vscode.call("workbench.action.debug.stop")
  end, { noremap = true, desc = "Stop Debugging" })

  map("n", "<leader>dr", function()
    vscode.call("workbench.action.debug.restart")
  end, { noremap = true, desc = "Restart Debugging" })

  map("n", "<leader>db", function()
    vscode.call("editor.debug.action.toggleBreakpoint")
  end, { noremap = true, desc = "Toggle Breakpoint" })

  map("n", "<leader>di", function()
    vscode.call("workbench.action.debug.stepInto")
  end, { noremap = true, desc = "Debug - step in" })

  map("n", "<leader>do", function()
    vscode.call("workbench.action.debug.stepOut")
  end, { noremap = true, desc = "Debug - step out" })

  map("n", "<leader>dO", function()
    vscode.call("workbench.action.debug.stepOver")
  end, { noremap = true, desc = "Debug - step over" })

  -- Copilot
  map("n", "<leader>aa", function()
    vscode.call("workbench.action.chat.open")
  end, { noremap = true, desc = "Ask Copilot" })

  map("n", "<leader>at", function()
    vscode.call("workbench.action.toggleAuxiliaryBar")
  end, { noremap = true, desc = "Toggle Copilot chat" })

  -- Http Client
  map("n", "<leader>Rs", function()
    vscode.call("vscode-hurl-runner.runHurl")
  end, { noremap = true, desc = "Send HTTP request" })

  map("n", "<leader>Ra", function()
    vscode.call("vscode-hurl-runner.runHurlFile")
  end, { noremap = true, desc = "Send HTTP all requests" })

  map("n", "<leader>Rr", function()
    vscode.call("vscode-hurl-runner.rerunLastCommand")
  end, { noremap = true, desc = "Replay HTTP requests" })

  map("n", "<leader>Rv", function()
    vscode.call("vscode-hurl-runner.viewLastResponse")
  end, { noremap = true, desc = "View Last Response" })

  -- Yazi
  map("n", "<leader>-", function()
    vscode.call("yazi-vscode.toggle")
  end, { noremap = true, desc = "Toggle Yazi" })

  -- Quarto
  map("n", "]4", function()
    vscode.call("quarto.goToNextCell")
  end, { noremap = true, desc = "Quarto Next code block" })

  map("n", "[4", function()
    vscode.call("quarto.goToPreviousCell")
  end, { noremap = true, desc = "Quarto Prev code block" })

  print("⚡ NEOVIM " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch)
end
