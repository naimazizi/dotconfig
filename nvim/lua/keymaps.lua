-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

vim.keymap.set("", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason" })
vim.keymap.set("", "<leader>cl", function()
  Snacks.picker.lsp_config()
end, { desc = "Lsp Info" })

vim.keymap.set("n", "dm", function()
  local mark = vim.fn.input("Enter mark to delete: ")
  if mark ~= "" then
    vim.cmd("delmark " .. mark)
  end
end, { noremap = true, desc = "Delete specific mark" })

-- buffers
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>bd", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>bo", function()
  Snacks.bufdelete.other()
end, { desc = "Delete Other Buffers" })
vim.keymap.set("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
vim.keymap.set(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Add undo break-points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

-- save file
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

--keywordprg
vim.keymap.set("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- location list
vim.keymap.set("n", "<leader>xl", function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(tostring(err), vim.log.levels.ERROR)
  end
end, { desc = "Location List" })

-- quickfix list
vim.keymap.set("n", "<leader>xq", function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(tostring(err), vim.log.levels.ERROR)
  end
end, { desc = "Quickfix List" })

vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local count = next and 1 or -1
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump({ count = count, severity = severity })
  end
end
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- quit
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- highlights under cursor
vim.keymap.set("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
vim.keymap.set("n", "<leader>uI", function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input("I")
end, { desc = "Inspect Tree" })

-- windows
vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Disable defaults
pcall(vim.keymap.del, "n", "gra")
pcall(vim.keymap.del, "n", "gri")
pcall(vim.keymap.del, "n", "grn")
pcall(vim.keymap.del, "n", "grr")
pcall(vim.keymap.del, "n", "grt")

-- VSCode keymaps
if vim.g.vscode then
  -- VSCode-specific keymaps for search and navigation
  vim.keymap.set("n", "<leader><space>", "<cmd>Find<cr>")
  vim.keymap.set("n", "<leader>/", [[<cmd>lua require('vscode').action('workbench.action.findInFiles')<cr>]])
  vim.keymap.set("n", "<leader>ss", [[<cmd>lua require('vscode').action('workbench.action.gotoSymbol')<cr>]])

  -- Keep undo/redo lists in sync with VsCode
  vim.keymap.set("n", "u", "<Cmd>call VSCodeNotify('undo')<CR>")
  vim.keymap.set("n", "<C-r>", "<Cmd>call VSCodeNotify('redo')<CR>")

  -- Navigate VSCode tabs like vim buffers
  vim.keymap.set("n", "<S-h>", "<Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>")
  vim.keymap.set("n", "<S-l>", "<Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>")

  local vscode = require("vscode")

  -- Delete keymap
  vim.keymap.del("n", "<leader>qq")

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
    vscode.call("jupyter.execSelectionInteractive")
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
    vscode.call("workbench.action.toggleSidebarVisibility")
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

  -- Quarto
  vim.keymap.set("n", "]4", function()
    vscode.call("quarto.goToNextCell")
  end, { noremap = true, desc = "Quarto Next code block" })

  vim.keymap.set("n", "[4", function()
    vscode.call("quarto.goToPreviousCell")
  end, { noremap = true, desc = "Quarto Prev code block" })
else
  -- Window Navigation in Nvim only
  vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
  vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
  vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
  vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

  vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
  vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
  vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
  vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })
end
