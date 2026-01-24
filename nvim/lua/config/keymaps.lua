local map = vim.keymap.set
local silent = { silent = true }

local function fzf_lua_picker(fn, opts)
  return function(...)
    local ok, fzf = pcall(require, "fzf-lua")
    if not ok then
      local ok_lazy, lazy = pcall(require, "lazy")
      if ok_lazy and type(lazy.load) == "function" then
        lazy.load({ plugins = { "fzf-lua" } })
      end
      ok, fzf = pcall(require, "fzf-lua")
      if not ok then
        vim.notify("fzf-lua not available")
        return
      end
    end
    local merged_opts = vim.tbl_extend("force", opts or {}, select(1, ...) or {})
    return fzf[fn](merged_opts)
  end
end

-- LazyVim-ish
map("n", "<Esc>", "<cmd>nohlsearch<cr><Esc>", { silent = true, desc = "Clear hlsearch" })

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
    if predicate(buf) then
      delete_buf(buf, force)
    end
  end
end

map("n", "<S-h>", "<cmd>bprevious<cr>", { silent = true, desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { silent = true, desc = "Next buffer" })

-- list all buffers
map("n", "<leader>bb", fzf_lua_picker("buffers", {}), { silent = false, desc = "List buffers" })
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

-- DAP (LazyVim-ish)
local function with_dap(fn)
  return function()
    local ok, dap = pcall(require, "dap")
    if not ok then
      vim.notify("nvim-dap not available")
      return
    end
    fn(dap)
  end
end

local function with_dapui(fn)
  return function()
    local ok, dapui = pcall(require, "dapui")
    if not ok then
      vim.notify("nvim-dap-ui not available")
      return
    end
    fn(dapui)
  end
end

map(
  "n",
  "<leader>db",
  with_dap(function(dap)
    dap.toggle_breakpoint()
  end),
  { silent = true, desc = "Toggle breakpoint" }
)

map(
  "n",
  "<leader>dB",
  with_dap(function(dap)
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end),
  { silent = true, desc = "Breakpoint condition" }
)

map(
  "n",
  "<leader>dL",
  with_dap(function(dap)
    dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
  end),
  { silent = true, desc = "Log point" }
)

map(
  "n",
  "<leader>dc",
  with_dap(function(dap)
    dap.continue()
  end),
  { silent = true, desc = "Continue" }
)

map(
  "n",
  "<leader>dC",
  with_dap(function(dap)
    dap.run_to_cursor()
  end),
  { silent = true, desc = "Run to cursor" }
)

map(
  "n",
  "<leader>dp",
  with_dap(function(dap)
    dap.pause()
  end),
  { silent = true, desc = "Pause" }
)

map(
  "n",
  "<leader>di",
  with_dap(function(dap)
    dap.step_into()
  end),
  { silent = true, desc = "Step into" }
)

map(
  "n",
  "<leader>do",
  with_dap(function(dap)
    dap.step_over()
  end),
  { silent = true, desc = "Step over" }
)

map(
  "n",
  "<leader>dO",
  with_dap(function(dap)
    dap.step_out()
  end),
  { silent = true, desc = "Step out" }
)

map(
  "n",
  "<leader>dl",
  with_dap(function(dap)
    dap.run_last()
  end),
  { silent = true, desc = "Run last" }
)

map(
  "n",
  "<leader>dr",
  with_dap(function(dap)
    dap.repl.toggle()
  end),
  { silent = true, desc = "Toggle REPL" }
)

map(
  "n",
  "<leader>dt",
  with_dap(function(dap)
    dap.terminate()
  end),
  { silent = true, desc = "Terminate" }
)

map(
  "n",
  "<leader>du",
  with_dapui(function(dapui)
    dapui.toggle()
  end),
  { silent = true, desc = "DAP UI" }
)

map(
  { "n", "v" },
  "<leader>de",
  with_dapui(function(dapui)
    dapui.eval()
  end),
  { silent = true, desc = "Eval" }
)

map("n", "<leader>dd", fzf_lua_picker("dap_commands", {}), { silent = true, desc = "DAP commands" })

map("n", "<leader>dv", fzf_lua_picker("dap_variables", {}), { silent = true, desc = "DAP variables" })

map("n", "<leader>dV", fzf_lua_picker("dap_breakpoints", {}), { silent = true, desc = "DAP breakpoint" })

map("n", "<leader>df", fzf_lua_picker("dap_configurations", {}), { silent = true, desc = "Configuration" })

-- Code formatting (conform.nvim)
map("n", "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { silent = true, desc = "Format" })
map("x", "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { silent = true, desc = "Format selection" })

-- Mason (LazyVim-ish)
map("n", "<leader>cm", "<cmd>Mason<cr>", { silent = true, desc = "Mason" })

-- Quickfix / location list (LazyVim-ish)
map("n", "<leader>xl", fzf_lua_picker("quickfix", {}), { silent = true, desc = "Location list" })
map("n", "<leader>xq", fzf_lua_picker("quickfix", {}), { silent = true, desc = "Quickfix" })
map("n", "<leader>xx", fzf_lua_picker("diagnostics", {}), { silent = true, desc = "Diagnostics" })
map("n", "[q", "<cmd>cprev<cr>", { silent = true, desc = "Prev quickfix" })
map("n", "]q", "<cmd>cnext<cr>", { silent = true, desc = "Next quickfix" })
map("n", "[l", "<cmd>lprev<cr>", { silent = true, desc = "Prev location" })
map("n", "]l", "<cmd>lnext<cr>", { silent = true, desc = "Next location" })

-- Files / search (fzf-lua)
map("n", "<leader>ff", fzf_lua_picker("files", {}), { silent = true, desc = "Find files" })

map(
  "n",
  "<leader>fF",
  fzf_lua_picker("files", { cwd = vim.fn.expand("%:p:h") }),
  { silent = true, desc = "Find files (cwd)" }
)

map("n", "<leader>fg", fzf_lua_picker("live_grep", {}), { silent = true, desc = "Grep" })

-- LazyVim uses `<leader>/` for grep (root). Here we treat cwd as root.
map("n", "<leader>/", fzf_lua_picker("live_grep", { cwd = vim.fn.getcwd() }), { silent = true, desc = "Grep (cwd)" })

map(
  "n",
  "<leader>sw",
  fzf_lua_picker("grep_string", { search = vim.fn.expand("<cword>") }),
  { silent = true, desc = "Search word under cursor" }
)

map("v", "<leader>sw", function()
  local start_pos = vim.fn.getpos("v")
  local end_pos = vim.fn.getpos(".")
  local start_row, start_col = (start_pos[2] or 1) - 1, (start_pos[3] or 1) - 1
  local end_row, end_col = (end_pos[2] or 1) - 1, (end_pos[3] or 1)

  ---@cast start_row integer
  ---@cast start_col integer
  ---@cast end_row integer
  ---@cast end_col integer

  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end

  ---@cast start_row integer
  ---@cast start_col integer
  ---@cast end_row integer
  ---@cast end_col integer

  local lines = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})
  local text = table.concat(lines, "\n")
  if text == "" then
    return
  end
  fzf_lua_picker("grep_string", { search = text })()
end, { silent = true, desc = "Search selection" })

-- Search/Replace (grug-far)
map("n", "<leader>sr", function()
  local grug = require("grug-far")
  local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
  grug.open({
    transient = true,
    prefills = {
      filesFilter = ext and ext ~= "" and "*." .. ext or nil,
    },
  })
end, { silent = true, desc = "Search/Replace (grug-far)" })

map("n", "<leader>sR", fzf_lua_picker("resume", {}), { silent = true, desc = "Resume" })

map("n", "<leader>sk", fzf_lua_picker("keymaps", {}), { silent = true, desc = "Keymaps" })

map("n", "<leader>sm", fzf_lua_picker("marks", {}), { silent = true, desc = "Marks" })

map("n", "<leader>st", fzf_lua_picker("live_grep", { search = "TODO|FIXME|FIX" }), { silent = true, desc = "TODO" })

map("n", "<leader>sd", fzf_lua_picker("diagnostics_document", {}), { silent = true, desc = "Diagnostics" })

map("n", "<leader>sD", fzf_lua_picker("diagnostics_workspace", {}), { silent = true, desc = "Diagnostics Workspace" })

map("n", "<leader>fb", fzf_lua_picker("buffers", {}), { silent = true, desc = "Buffers" })

map("n", "<leader>fr", fzf_lua_picker("oldfiles", {}), { silent = true, desc = "Recent" })

map("n", "<leader>fn", function()
  local ok, notify = pcall(require, "mini.notify")
  if ok then
    notify.show_history()
    return
  end
  vim.notify("mini.notify not available")
end, { silent = true, desc = "Notifications" })

map("n", "<leader>fh", fzf_lua_picker("help_tags", {}), { silent = true, desc = "Help" })

map("n", "<leader>fz", fzf_lua_picker("zoxide", {}), { silent = true, desc = "Zoxide" })

map("n", "<leader>s/", fzf_lua_picker("command_history", {}), { silent = true, desc = "Command History" })

-- Alternative fast file picker (fff.nvim)
map("n", "<leader><space>", function()
  require("fff").find_files()
end, { silent = true, desc = "Find files (fff)" })

-- Picker (Git)
map("n", "<leader>gc", fzf_lua_picker("git_bcommits", {}), { silent = true, desc = "Buffer Commits" })

map("n", "<leader>gC", fzf_lua_picker("git_commits", {}), { silent = true, desc = "Commits" })

map("n", "<leader>gd", fzf_lua_picker("git_diff", {}), { silent = true, desc = "Diff" })

map("n", "<leader>gB", function()
  Snacks.gitbrowse()
end, { silent = true, desc = "Browse" })

map("n", "<leader>gi", function()
  Snacks.picker.gh_issue()
end, { silent = true, desc = "GitHub Issues (open)" })

map("n", "<leader>gI", function()
  Snacks.picker.gh_issue({ state = "all" })
end, { silent = true, desc = "GitHub Issues (all)" })

map("n", "<leader>gp", function()
  Snacks.picker.gh_pr()
end, { silent = true, desc = "GitHub Pull Requests (open)" })

map("n", "<leader>gP", function()
  Snacks.picker.gh_pr({ state = "all" })
end, { silent = true, desc = "GitHub Pull Requests (all)" })

-- Terminal
map("n", "<C-/>", "<cmd>lua Snacks.terminal.toggle()<CR>", { silent = true, desc = "Toggle terminal" })
map("n", "<leader>ft", "<cmd>lua Snacks.terminal()<CR>", { silent = true, desc = "Toggle terminal" })

-- Git (gitsigns)
map("n", "<leader>gg", function()
  Snacks.lazygit()
end, { silent = true, desc = "lazygit (toggleterm)" })

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
map("n", "z1", "zM", { noremap = true, desc = "Fold 1" })
map("n", "z2", "zM1zr", { noremap = true, desc = "Fold 2" })
map("n", "z3", "zM2zr", { noremap = true, desc = "Fold 3" })
map("n", "z4", "zM3zr", { noremap = true, desc = "Fold 4" })

-- Center buffer (zen-mode)
map("n", "<leader>uz", "<cmd>NoNeckPain<cr>", { noremap = true, desc = "Toggle zen-mode" })

-- neovide
if vim.g.neovide then
  map("n", "<D-s>", ":w<CR>") -- Save
  map("v", "<D-c>", '"+y') -- Copy
  map("n", "<D-v>", '"+P') -- Paste normal mode
  map("v", "<D-v>", '"+P') -- Paste visual mode
  map("c", "<D-v>", "<C-R>+") -- Paste command mode
  map("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode
end
