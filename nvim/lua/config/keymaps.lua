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

-- list all buffers
map("n", "<leader>bb", function()
  require("mini.pick").builtin.buffers()
end, { silent = false, desc = "List buffers" })
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

-- LazyVim-ish LSP/diagnostics mappings
map("n", "<leader>cd", vim.diagnostic.open_float, { silent = true, desc = "Line diagnostics" })
map("n", "<leader>cl", "<cmd>LspInfo<cr>", { silent = true, desc = "Lsp Info" })
map("n", "<leader>cq", vim.diagnostic.setloclist, { silent = true, desc = "Quickfix diagnostics" })

map("n", "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { silent = true, desc = "Format" })
map("x", "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { silent = true, desc = "Format selection" })

map("n", "<leader>cm", "<cmd>Mason<cr>", { silent = true, desc = "Mason" })

-- Quickfix / location list (LazyVim-ish)
map("n", "<leader>xl", "<cmd>lopen<cr>", { silent = true, desc = "Location list" })
map("n", "<leader>xq", "<cmd>copen<cr>", { silent = true, desc = "Quickfix" })
map("n", "<leader>xx", function()
  require("mini.extra").pickers.diagnostic()
end, { silent = true, desc = "Diagnostics" })
map("n", "[q", "<cmd>cprev<cr>", { silent = true, desc = "Prev quickfix" })
map("n", "]q", "<cmd>cnext<cr>", { silent = true, desc = "Next quickfix" })
map("n", "[l", "<cmd>lprev<cr>", { silent = true, desc = "Prev location" })
map("n", "]l", "<cmd>lnext<cr>", { silent = true, desc = "Next location" })

-- Explorer (LazyVim defaults)
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { silent = true, desc = "Explorer" })
map("n", "<leader>E", "<cmd>NvimTreeFindFile<cr>", { silent = true, desc = "Explorer (reveal file)" })

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

-- LazyVim uses `<leader>/` for grep (root). Here we treat cwd as root.
map("n", "<leader>/", function()
  require("mini.pick").builtin.grep_live({ source = { cwd = vim.fn.getcwd() } })
end, { silent = true, desc = "Grep (cwd)" })

map("n", "<leader>sw", function()
  require("mini.pick").builtin.grep({ pattern = vim.fn.expand("<cword>") })
end, { silent = true, desc = "Search word under cursor" })

map("v", "<leader>sw", function()
  local start_pos = vim.fn.getpos("v")
  local end_pos = vim.fn.getpos(".")
  local start_row, start_col = start_pos[2] - 1, start_pos[3] - 1
  local end_row, end_col = end_pos[2] - 1, end_pos[3]
  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end
  local lines = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})
  local text = table.concat(lines, "\n")
  if text == "" then
    return
  end
  require("mini.pick").builtin.grep({ pattern = text })
end, { silent = true, desc = "Search selection" })

-- Search/Replace (grug-far)
map("n", "<leader>sr", function()
  require("grug-far").open()
end, { silent = true, desc = "Search/Replace (grug-far)" })

map("n", "<leader>sR", function()
  require("mini.pick").resume()
end, { silent = true, desc = "Resume" })

map("n", "<leader>sk", function()
  require("mini.extra").pickers.keymaps()
end, { silent = true, desc = "Keymaps" })

map("n", "<leader>sm", function()
  require("mini.extra").pickers.marks()
end, { silent = true, desc = "Marks" })

map("n", "<leader>st", function()
  require("mini.pick").builtin.grep({ pattern = [[(TODO|FIXME|FIX)]] })
end, { silent = true, desc = "TODO" })

map("n", "<leader>sd", function()
  require("mini.extra").pickers.diagnostic()
end, { silent = true, desc = "Diagnostics" })

map("n", "<leader>fb", function()
  require("mini.pick").builtin.buffers()
end, { silent = true, desc = "Buffers" })

map("n", "<leader>fr", function()
  require("mini.extra").pickers.oldfiles()
end, { silent = true, desc = "Recent" })

map("n", "<leader>fn", function()
  local ok, notify = pcall(require, "mini.notify")
  if ok then
    notify.show_history()
    return
  end
  vim.notify("mini.notify not available")
end, { silent = true, desc = "Notifications" })

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

-- Lazy manager
map("n", "<leader>l", "<cmd>Lazy<cr>", { silent = true, desc = "Lazy" })

-- Fold
vim.keymap.set("n", "z1", "zM", { noremap = true, desc = "Fold 1" })
vim.keymap.set("n", "z2", "zM1zr", { noremap = true, desc = "Fold 2" })
vim.keymap.set("n", "z3", "zM2zr", { noremap = true, desc = "Fold 3" })
vim.keymap.set("n", "z4", "zM3zr", { noremap = true, desc = "Fold 4" })

-- mark
vim.keymap.set("n", "dm", function()
  local mark = vim.fn.input("Enter mark to delete: ")
  if mark ~= "" then
    vim.cmd("delmark " .. mark)
  end
end, { noremap = true, desc = "Delete specific mark" })

-- neovide
if vim.g.neovide then
  vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
  vim.keymap.set("v", "<D-c>", '"+y') -- Copy
  vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
  vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
  vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
  vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode
end
