-- VScode specific config
local vscode = require("vscode")

-- Autocmds
-- Redraw fixes for VSCode visual artifacts (moved from autocmds.lua)
local redraw_fix = vim.api.nvim_create_augroup("VSCodeRedrawFix", { clear = true })

-- Redraw on cursor hold to fix visual artifacts
vim.api.nvim_create_autocmd("CursorHold", {
  group = redraw_fix,
  callback = function()
    vim.cmd("silent! mode") -- triggers a lightweight redraw
  end,
})

-- Redraw immediately after text changes (e.g., visual delete)
local redraw_group = vim.api.nvim_create_augroup("RedrawOnDelete", { clear = true })
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
  group = redraw_group,
  callback = function()
    if vim.fn.mode() == "n" then
      vim.cmd("silent! mode") -- refresh UI after delete/insert
    end
  end,
})

-- Update line numbers on mode changes and redraw to fix selection artifacts.
vim.api.nvim_create_autocmd("ModeChanged", {
  group = redraw_fix,
  callback = function()
    local mode = vim.api.nvim_get_mode().mode
    vscode.eval_async(
      [[
      const editor = vscode.window.activeTextEditor;
      if (editor) {
        editor.options.lineNumbers = args
          ? vscode.TextEditorLineNumbersStyle.Relative
          : vscode.TextEditorLineNumbersStyle.On;
      }
    ]],
      { args = mode == "v" or mode == "V" or mode == "\22" }
    )
    vim.cmd("silent! mode")
  end,
})

-- Redraw on window operations
vim.api.nvim_create_autocmd({ "WinEnter", "WinLeave" }, {
  group = redraw_fix,
  callback = function()
    vim.cmd("silent! mode")
  end,
})

-- KEYMAPS
local map = vim.keymap.set

-- Code Telescope finders, using Neovim's leader-key layout.
for _, finder in ipairs({
  { "<leader><leader>", "file", "Find workspace files" },
  { "<leader>/", "wsText", "Search workspace text" },
  { "<leader>sb", "fileText", "Search current file text" },
  { "<leader>fo", "recentFiles", "Recent files" },
  { "<leader>gB", "branch", "Git branches" },
  { "<leader>gd", "diff", "Git diffs" },
  { "<leader>gC", "commit", "Git commits" },
  { "<leader>ci", "callHierarchy", "Call hierarchy" },
  { "<leader>sk", "keybindings", "Keybindings" },
  { "<leader>uc", "colorschemes", "Color schemes" },
  { "<leader>oo", "tasks", "Tasks" },
  { "<leader>dk", "breakpoints", "Breakpoints" },
  { "<leader>ux", "extensions", "Extensions" },
  { "<leader>fh", "pkgDocs", "Package docs" },
  { "<leader>uF", "fontFamily", "Font family" },
  { "<leader>hh", "harpoon", "Harpoon marks" },
  { "<leader>sr", "resume", "Resume last finder" },
}) do
  map("n", finder[1], function()
    vscode.call("code-telescope.fuzzy." .. finder[2])
  end, { desc = finder[3] })
end

-- VS Code commands; mode defaults to normal mode.
for _, binding in ipairs({
  -- Editor management
  { "<leader>bd", "workbench.action.closeActiveEditor", "Close editor" },
  { "<leader>bo", "workbench.action.closeOtherEditors", "Close other editors in group" },
  { "<leader>bn", "workbench.action.files.newUntitledFile", "New file" },
  { "[b", "workbench.action.previousEditor", "Previous editor" },
  { "]b", "workbench.action.nextEditor", "Next editor" },
  { "<leader>bb", "workbench.action.showAllEditors", "List open editors" },

  -- UI and layout
  { "<leader>uw", "editor.action.toggleWordWrap", "Toggle word wrap" },
  { "<leader>uz", "workbench.action.toggleZenMode", "Toggle Zen Mode" },
  { "<leader>|", "workbench.action.splitEditorRight", "Split editor right" },

  -- Diagnostics
  { "[d", "editor.action.marker.prev", "Previous diagnostic" },
  { "]d", "editor.action.marker.next", "Next diagnostic" },
  { "<leader>sd", "workbench.panel.markers.view.focus", "Open Problems panel" },
  { "<leader>sD", "workbench.panel.markers.view.focus", "Open Problems panel" },

  -- Git changes
  { "<leader>gv", "git.openChange", "Show file diff" },
  { "<leader>gs", "git.stageSelectedRanges", "Stage selected Git ranges" },
  { "<leader>gS", "git.unstage", "Unstage file" },

  -- Terminal
  { "<leader>ft", "workbench.action.terminal.toggleTerminal" },
  { "<leader>fT", "workbench.action.terminal.toggleTerminal" },
  { "<c-/>", "workbench.action.terminal.toggleTerminal" },

  -- Comments
  { "gc", "editor.action.commentLine", "Toggle Comment Line (Visual) -- it mimics ctrl+/", mode = "v" },

  -- Highlighted-word navigation
  { "[w", "editor.action.wordHighlight.prev", "Previous Highlighted word" },
  { "]w", "editor.action.wordHighlight.next", "Next Highlighted word" },

  -- Tab navigation
  { "<S-l>", "workbench.action.nextEditor", "switch between editor to next" },
  { "<S-h>", "workbench.action.previousEditor", "switch between editor to previous" },

  -- LSP and code actions
  { "<leader>ss", "workbench.action.gotoSymbol" },
  { "<leader>sS", "workbench.action.showAllSymbols" },
  { "gr", "editor.action.referenceSearch.trigger", "peek references inside vs code" },
  { "gd", "editor.action.revealDefinition", "go to definition inside vs code" },
  { "gD", "editor.action.revealDeclaration", "go to declaration inside vs code" },
  { "gI", "editor.action.peekImplementation", "peek Implementation inside vs code" },
  { "gi", "editor.action.goToImplementation", "Go to implementation" },
  { "gy", "editor.action.goToTypeDefinition", "go to type definition inside vs code" },
  { "<leader>e", "workbench.files.action.focusFilesExplorer", "focus to file explorer" },
  { "<leader>fe", "workbench.files.action.focusFilesExplorer", "focus to file explorer" },
  { "<leader>cr", "editor.action.rename", "rename symbol" },
  { "<leader>ca", "editor.action.quickFix", "open quick fix in vs code" },
  { "<leader>cA", "editor.action.sourceAction", "open source Action in vs code" },
  { "<leader>cp", "workbench.panel.markers.view.focus", "open problems diagnostics" },
  { "<leader>cd", "editor.action.showHover", "Show hover and diagnostic details" },
  { "<leader>co", "editor.action.organizeImports", "organize import" },
  { "<leader>cs", "outline.focus", "Focus outline", silent = true },
  { "<leader>cf", "editor.action.formatDocument", "Format Document", silent = true },

  -- Navigation
  { "[e", "editor.action.marker.prev", "Go to Previous Problem (error, warning, info)", mode = { "n", "v" } },
  { "]e", "editor.action.marker.next", "Go to Next Problem (error, warning, info)", mode = { "n", "v" } },
  { "[h", "workbench.action.editor.previousChange", "Go to Prev Change" },
  { "]h", "workbench.action.editor.nextChange", "Go to Next Change" },
  { "[t", "todo-tree.goToPrevious", "Go to Prev Change" },
  { "]t", "todo-tree.goToNext", "Go to Next Change" },

  -- Code Telescope Harpoon
  { "<leader>H", "code-telescope.harpoon.addFile", "Harpoon add file" },
  { "<leader>hd", "code-telescope.harpoon.removeCurrentFile", "Harpoon remove current file" },
  { "<leader>hC", "code-telescope.harpoon.clear", "Harpoon clear marks" },

  -- Jupyter
  { "<localleader>rr", "jupyter.runcurrentcell", "Run Jupyter - current cell" },
  { "<localleader>ru", "jupyter.runallcellsabove.palette", "Run Jupyter - until cursor" },
  { "<localleader>re", "jupyter.execSelectionInteractive", "Run Jupyter - Send line" },
  { "<localleader>r<localleader>", "jupyter.interruptkernel", "Run Jupyter - interrupt kernel" },

  -- Folding: zm/zr have no equivalent; zM/zR close/open everything.
  { "za", "editor.toggleFold", "Toggle Fold" },
  { "zA", "editor.toggleFoldRecursively", "Toggle All Fold Recursively" },
  { "zc", "editor.fold", "Fold" },
  { "zC", "editor.foldRecursively", "Fold All Recursively" },
  { "zM", "editor.foldAll", "Close All Folds" },
  { "zo", "editor.unfold", "Open Fold" },
  { "zO", "editor.unfoldRecursively", "Open Fold Recursively" },
  { "zR", "editor.unfoldAll", "Open Fold all" },
  { "z/", "editor.foldAllBlockComments", "Fold all block comments" },
  { "zj", "editor.gotoNextFold", "Go to Next Fold" },
  { "zk", "editor.gotoPreviousFold", "Go to Previous Fold" },

  -- Tests and source control
  { "<leader>td", "testing.debugAtCursor", "Debug Nearest Test" },
  { "<leader>tr", "testing.runAtCursor", "Run Nearest Test" },
  { "<leader>tt", "testing.runCurrentFile", "Run Test from current file" },
  { "<leader>tT", "testing.runAll", "Run All Test" },
  { "<leader>ts", "workbench.view.testing.focus", "Show Test Results" },
  { "<leader>gg", "lazygit-vscode.toggle", "Toggle Lazygit" },

  -- Debugging
  { "<leader>dd", "workbench.action.debug.start", "Start Debugging" },
  { "<leader>dt", "workbench.action.debug.stop", "Stop Debugging" },
  { "<leader>dr", "workbench.debug.action.toggleRepl", "Toggle Debug Console" },
  { "<leader>dc", "workbench.action.debug.continue", "Continue debugging" },
  { "<leader>dp", "workbench.action.debug.pause", "Pause debugging" },
  { "<leader>db", "editor.debug.action.toggleBreakpoint", "Toggle Breakpoint" },
  { "<leader>di", "workbench.action.debug.stepInto", "Debug - step in" },
  { "<leader>do", "workbench.action.debug.stepOver", "Debug - step over" },
  { "<leader>dO", "workbench.action.debug.stepOut", "Debug - step out" },

  -- HTTP, Yazi, Quarto, and AI
  { "<leader>Rs", "vscode-hurl-runner.runHurl", "Send HTTP request" },
  { "<leader>Ra", "vscode-hurl-runner.runHurlFile", "Send HTTP all requests" },
  { "<leader>Rr", "vscode-hurl-runner.rerunLastCommand", "Replay HTTP requests" },
  { "<leader>Rv", "vscode-hurl-runner.viewLastResponse", "View Last Response" },
  { "<leader>-", "yazi-vscode.toggle", "Toggle Yazi" },
  { "]4", "quarto.goToNextCell", "Quarto Next code block" },
  { "[4", "quarto.goToPreviousCell", "Quarto Prev code block" },
  { "<leader>aa", "varro.chat.focus", "Focus Varro chat" },
  { "<leader>as", "varro.chat.searchSessions", "Search Varro sessions" },
  { "<leader>ac", "varro.chat.addToContext", "Add to Varro context" },
}) do
  map(binding.mode or "n", binding[1], function()
    vscode.call(binding[2])
  end, { desc = binding[3], silent = binding.silent })
end

for i = 1, 9 do
  map("n", "<leader>" .. i, function()
    vscode.call("code-telescope.harpoon.gotoFile" .. i)
  end, { desc = "Harpoon file " .. i })
end

for i = 1, 7 do
  map("n", "z" .. i, function()
    vscode.call("editor.foldLevel" .. i)
  end, { desc = "Fold level " .. i })
end
