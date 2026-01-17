local map = vim.keymap.set
local silent = { silent = true }

-- LazyVim-ish
map("n", "<Esc>", "<cmd>nohlsearch<cr><Esc>", { silent = true, desc = "Clear hlsearch" })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", silent)
map("n", "<C-j>", "<C-w>j", silent)
map("n", "<C-k>", "<C-w>k", silent)
map("n", "<C-l>", "<C-w>l", silent)

-- Save file
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { silent = true, desc = "Save file" })

-- Toggle autoformat (LazyVim-ish)
map("n", "<leader>uf", function()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify("Autoformat " .. (vim.g.autoformat and "enabled" or "disabled"))
end, { silent = true, desc = "Toggle autoformat" })

-- Notifications (mini.notify)
map("n", "<leader>n", function()
  local ok, notify = pcall(require, "mini.notify")
  if ok then
    notify.show_history()
    return
  end
  vim.notify("mini.notify not available")
end, { silent = true, desc = "Notifications" })

-- Sessions / quit (LazyVim-ish)
map("n", "<leader>qq", "<cmd>qa<cr>", { silent = true, desc = "Quit all" })
map("n", "<leader>qs", function()
  require("mini.sessions").select()
end, { silent = true, desc = "Select session" })
map("n", "<leader>qS", function()
  local path = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
  path = path:gsub("^~/?", ""):gsub("/", "%%"):gsub("%%+$", "")
  require("mini.sessions").write(path)
end, { silent = true, desc = "Save session" })
map("n", "<leader>ql", function()
  require("mini.sessions").read()
end, { silent = true, desc = "Restore session" })
map("n", "<leader>qd", function()
  local name = vim.v.this_session
  if name == nil or name == "" then
    vim.notify("No active session")
    return
  end
  require("mini.sessions").delete(name, { force = true })
end, { silent = true, desc = "Delete current session" })

-- Buffers (LazyVim-ish)
-- Note: MiniBufremove is used so window layout stays intact.
local pinned_buffers = {}

local function is_listed(buf)
  return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
end

local function bufs_listed()
  local out = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if is_listed(buf) then
      table.insert(out, buf)
    end
  end
  table.sort(out)
  return out
end

local function delete_buf(buf, force)
  require("mini.bufremove").delete(buf or 0, force or false)
end

local function delete_where(predicate, force)
  for _, buf in ipairs(bufs_listed()) do
    if predicate(buf) and not pinned_buffers[buf] then
      delete_buf(buf, force)
    end
  end
end

map("n", "<S-h>", "<cmd>bprevious<cr>", { silent = true, desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { silent = true, desc = "Next buffer" })

-- New buffer
map("n", "<leader>bn", "<cmd>enew<cr>", { silent = true, desc = "New buffer" })

-- Delete/close buffers
map("n", "<leader>bd", function()
  delete_buf(0, false)
end, { silent = true, desc = "Delete buffer" })
map("n", "<leader>bD", function()
  delete_buf(0, true)
end, { silent = true, desc = "Delete buffer (force)" })

-- Delete other buffers
map("n", "<leader>bo", function()
  local current = vim.api.nvim_get_current_buf()
  delete_where(function(buf)
    return buf ~= current
  end, true)
end, { silent = true, desc = "Delete other buffers" })

-- Delete buffers to the left/right
map("n", "<leader>bh", function()
  local current = vim.api.nvim_get_current_buf()
  local current_nr = vim.fn.bufnr("%")
  delete_where(function(buf)
    return buf ~= current and vim.fn.bufnr(buf) < current_nr
  end, true)
end, { silent = true, desc = "Delete buffers to the left" })

map("n", "<leader>bl", function()
  local current = vim.api.nvim_get_current_buf()
  local current_nr = vim.fn.bufnr("%")
  delete_where(function(buf)
    return buf ~= current and vim.fn.bufnr(buf) > current_nr
  end, true)
end, { silent = true, desc = "Delete buffers to the right" })

-- Delete all buffers (respects pinned)
map("n", "<leader>bA", function()
  delete_where(function(_)
    return true
  end, true)
end, { silent = true, desc = "Delete all buffers" })

-- Pin buffer (not a mini.nvim feature, implemented here)
map("n", "<leader>bp", function()
  local buf = vim.api.nvim_get_current_buf()
  pinned_buffers[buf] = not pinned_buffers[buf]
  vim.notify(("Buffer %s"):format(pinned_buffers[buf] and "pinned" or "unpinned"))
end, { silent = true, desc = "Pin buffer" })

-- TODO/NOTE/FIX comment navigation (via mini.bracketed)
map("n", "[t", function()
  require("mini.bracketed").comment("backward")
end, { silent = true, desc = "Prev todo comment" })
map("n", "]t", function()
  require("mini.bracketed").comment("forward")
end, { silent = true, desc = "Next todo comment" })

map("n", "<leader>cd", vim.diagnostic.open_float, { silent = true, desc = "Line diagnostics" })
map("n", "<leader>cl", "<cmd>LspInfo<cr>", { silent = true, desc = "Lsp Info" })
map("n", "<leader>cq", vim.diagnostic.setloclist, { silent = true, desc = "Quickfix diagnostics" })

-- Quickfix / location list (LazyVim-ish)
map("n", "<leader>xl", "<cmd>lopen<cr>", { silent = true, desc = "Location list" })
map("n", "[q", "<cmd>cprev<cr>", { silent = true, desc = "Prev quickfix" })
map("n", "]q", "<cmd>cnext<cr>", { silent = true, desc = "Next quickfix" })
map("n", "[l", "<cmd>lprev<cr>", { silent = true, desc = "Prev location" })
map("n", "]l", "<cmd>lnext<cr>", { silent = true, desc = "Next location" })

-- Files / finders
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { silent = true, desc = "Explorer" })

-- Files / search (mini.pick)
map("n", "<leader>ff", function()
  require("mini.pick").builtin.files()
end, { silent = true, desc = "Find files" })

map("n", "<leader>fF", function()
  require("mini.pick").builtin.files({ source = { cwd = vim.fn.expand("%:p:h") } })
end, { silent = true, desc = "Find files (cwd)" })

map("n", "<leader>fg", function()
  require("mini.pick").builtin.grep_live()
end, { silent = true, desc = "Grep" })

map("n", "<leader>/", function()
  require("mini.pick").builtin.grep_live({ source = { cwd = vim.fn.getcwd() } })
end, { silent = true, desc = "Grep (cwd)" })

-- Search/Replace (grug-far)
map("n", "<leader>sr", function()
  require("grug-far").open()
end, { silent = true, desc = "Search/Replace (grug-far)" })

map("n", "<leader>fb", function()
  require("mini.pick").builtin.buffers()
end, { silent = true, desc = "Buffers" })

map("n", "<leader>fr", function()
  require("mini.extra").pickers.oldfiles()
end, { silent = true, desc = "Recent" })

map("n", "<leader>fh", function()
  require("mini.pick").builtin.help()
end, { silent = true, desc = "Help" })

-- Alternative fast file picker (fff.nvim)
map("n", "<leader><space>", function()
  require("fff").find_files()
end, { silent = true, desc = "Find files (fff)" })

-- Git (gitsigns)
map("n", "<leader>gg", function()
  if vim.fn.executable("gitui") == 0 then
    vim.notify("gitui not found in PATH")
    return
  end

  local ok, term = pcall(require, "toggleterm.terminal")
  if not ok then
    vim.notify("toggleterm.nvim not available")
    return
  end

  local Terminal = term.Terminal
  local gitui = Terminal:new({
    cmd = "gitui",
    direction = "float",
    hidden = true,
    close_on_exit = true,
  })

  gitui:toggle()
end, { silent = true, desc = "GitUI (toggleterm)" })

map("n", "]h", function()
  require("gitsigns").next_hunk()
end, { silent = true, desc = "Next hunk" })

map("n", "[h", function()
  require("gitsigns").prev_hunk()
end, { silent = true, desc = "Prev hunk" })

map({ "n", "v" }, "<leader>gs", function()
  require("gitsigns").stage_hunk()
end, { silent = true, desc = "Stage hunk" })

map({ "n", "v" }, "<leader>gr", function()
  require("gitsigns").reset_hunk()
end, { silent = true, desc = "Reset hunk" })

map("n", "<leader>gS", function()
  require("gitsigns").stage_buffer()
end, { silent = true, desc = "Stage buffer" })

map("n", "<leader>gR", function()
  require("gitsigns").reset_buffer()
end, { silent = true, desc = "Reset buffer" })

map("n", "<leader>gp", function()
  require("gitsigns").preview_hunk()
end, { silent = true, desc = "Preview hunk" })

map("n", "<leader>gb", function()
  require("gitsigns").toggle_current_line_blame()
end, { silent = true, desc = "Toggle line blame" })

-- Workspace symbols / document symbols
map("n", "<leader>ss", vim.lsp.buf.document_symbol, { silent = true, desc = "Symbols (document)" })
map("n", "<leader>sS", vim.lsp.buf.workspace_symbol, { silent = true, desc = "Symbols (workspace)" })

-- Selection range isn't always available; fall back safely
map({ "n", "x" }, "<leader>cs", function()
  local ok = pcall(vim.lsp.buf.selection_range)
  if not ok then
    vim.notify("Selection range not supported", vim.log.levels.WARN)
  end
end, { silent = true, desc = "Selection range" })

-- Diagnostics picker (mini.pick)
map("n", "<leader>xx", function()
  require("mini.extra").pickers.diagnostic()
end, { silent = true, desc = "Diagnostics" })

-- Tools
map("n", "<leader>cm", "<cmd>Mason<cr>", { silent = true, desc = "Mason" })

-- Formatting (Conform)
-- LazyVim-ish: <leader>cf
map("n", "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { silent = true, desc = "Format" })
map("x", "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { silent = true, desc = "Format selection" })

-- Debug (DAP)
map("n", "<leader>db", function()
  require("dap").toggle_breakpoint()
end, { desc = "Toggle breakpoint" })
map("n", "<leader>dc", function()
  require("dap").continue()
end, { desc = "Continue" })
map("n", "<leader>di", function()
  require("dap").step_into()
end, { desc = "Step into" })
map("n", "<leader>do", function()
  require("dap").step_over()
end, { desc = "Step over" })
map("n", "<leader>dO", function()
  require("dap").step_out()
end, { desc = "Step out" })
map("n", "<leader>dr", function()
  require("dap").repl.open()
end, { desc = "REPL" })
map("n", "<leader>du", function()
  require("dapui").toggle()
end, { desc = "DAP UI" })
map("n", "<leader>dt", function()
  require("dap").terminate()
end, { desc = "Terminate" })
map("n", "<leader>td", function()
  require("neotest").run.run({ strategy = "dap" })
end, { desc = "Debug Nearest" })

-- Search
map("n", "<leader>sd", function()
  require("mini.extra").pickers.diagnostic()
end, { silent = true, desc = "Diagnostics" })
map("n", "<leader>sr", function()
  require("mini.pick").resume()
end, { silent = true, desc = "Resume" })
map("n", "<leader>sk", function()
  require("mini.extra").pickers.keymaps()
end, { silent = true, desc = "Keymaps" })
map("n", "<leader>st", function()
  require("mini.pick").builtin.grep({
    pattern = [[(TODO|FIXME|FIX)]],
  })
end, { silent = true, desc = "TODO/FIXME/FIX" })
map("n", "<leader>sm", function()
  require("mini.extra").pickers.marks()
end, { silent = true, desc = "Marks" })

-- Search symbols (document/workspace)
map("n", "<leader>ss", vim.lsp.buf.document_symbol, { silent = true, desc = "Symbols (document)" })
map("n", "<leader>sS", vim.lsp.buf.workspace_symbol, { silent = true, desc = "Symbols (workspace)" })

-- Lazy manager
map("n", "<leader>l", "<cmd>Lazy<cr>", { silent = true, desc = "Lazy" })
