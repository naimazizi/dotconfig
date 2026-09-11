local map = vim.keymap.set

-- Delete without clobbering the unnamed/yank register (send to black hole register instead)
map({ "n", "x" }, "d", '"_d', { desc = "Delete (no register)" })
map("n", "D", '"_D', { desc = "Delete to EOL (no register)" })

-- Terminal escape
map("t", "<C-Esc>", "<C-\\><C-n>", { silent = true, desc = "Exit terminal mode" })

-- Move to other windows from terminal mode (leaves terminal-normal mode first)
map("t", "<C-w>", "<C-\\><C-n><C-w>", { silent = true, desc = "Window commands" })
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { silent = true, desc = "Move to left window" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { silent = true, desc = "Move to below window" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { silent = true, desc = "Move to above window" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { silent = true, desc = "Move to right window" })

-- Incremental selection
map({ "n", "x", "o" }, "<A-o>", function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require("vim.treesitter._select").select_parent(vim.v.count1)
  else
    vim.lsp.buf.selection_range(vim.v.count1)
  end
end, { desc = "Select parent treesitter node or outer incremental lsp selections" })

map({ "n", "x", "o" }, "<A-i>", function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require("vim.treesitter._select").select_child(vim.v.count1)
  else
    vim.lsp.buf.selection_range(-vim.v.count1)
  end
end, { desc = "Select child treesitter node or inner incremental lsp selections" })

-- Multicursor
map("n", "<A-d>", "Q", { noremap = true, desc = "Multicursor add cursor" })

map("n", "<A-r>", function()
  local mc_ns = vim.api.nvim_create_namespace("nvim.multicursor")
  vim.api.nvim_buf_clear_namespace(0, mc_ns, 0, -1)
end, { noremap = true, desc = "Multicursor clear All cursor" })

map("n", "<A-n>", function()
  local ns = vim.api.nvim_create_namespace("nvim.multicursor")
  local marks = vim.api.nvim_buf_get_extmarks(0, ns, 0, -1)
  if #marks ~= 0 then
    vim.api.nvim_feedkeys("Qn", "n", false) -- place a cursor and jump to the next match
    return
  end
  vim.api.nvim_feedkeys("wbQ", "n", false) -- move to the beginning of the word and place a cursor
  vim.fn.setreg("/", "\\V" .. vim.fn.expand("<cword>")) -- set search pattern to the current word
  vim.api.nvim_feedkeys("n", "n", false)
end, { noremap = true, desc = "Multicursor search word under cursor" })

map("n", "<A-C-n>", function()
  local ns = vim.api.nvim_create_namespace("nvim.multicursor")
  local _marks = vim.api.nvim_buf_get_extmarks(0, ns, 0, -1)
  vim.api.nvim_feedkeys("wbQ", "n", false) -- move to the beginning of the word and place a cursor
  vim.fn.setreg("/", "\\V" .. vim.fn.expand("<cword>")) -- set search pattern to the current word
  vim.api.nvim_feedkeys("n", "n", false)
end, { noremap = true, desc = "Multicursor search word under cursor" })

map("n", "<A-f>", "q=", { noremap = true, desc = "Multicursor follow" })
map("n", "<A-e>", "[CQ", { noremap = true, desc = "Multicursor delete current cursor" })

-- Neovim general keymaps
if not vim.g.vscode then
  -- Clear copilot suggestion with Esc if visible, otherwise preserve default Esc behavior
  map("n", "<esc>", function()
    vim.cmd("nohlsearch")
  end, { desc = "Clear" })

  -- Sessions / quit (LazyVim-ish)
  map("n", "<leader>qq", "<cmd>qa<cr>", { silent = true, desc = "Quit all" })

  -- New buffer
  map("n", "<leader>bn", "<cmd>enew<cr>", { silent = true, desc = "New buffer" })

  -- Switch buffers (barbar.nvim keymap, ported to native :b commands)
  map("n", "<S-h>", "<cmd>bprevious<cr>", { silent = true, desc = "Buffer Previous" })
  map("n", "<S-l>", "<cmd>bnext<cr>", { silent = true, desc = "Buffer Next" })
  map("n", "[b", "<cmd>bprevious<cr>", { silent = true, desc = "Buffer Previous" })
  map("n", "]b", "<cmd>bnext<cr>", { silent = true, desc = "Buffer Next" })

  -- LSP/diagnostics mappings
  map("n", "<leader>cd", vim.diagnostic.open_float, { silent = true, desc = "Line diagnostics" })
  map("n", "<leader>cl", "<cmd>checkhealth vim.lsp<cr>", { silent = true, desc = "Lsp Info" })

  -- Quickfix / location list (LazyVim-ish)
  map("n", "[l", "<cmd>lprev<cr>", { silent = true, desc = "Prev location" })
  map("n", "]l", "<cmd>lnext<cr>", { silent = true, desc = "Next location" })

  -- Split window
  map("n", "<leader>-", "<cmd>split<cr>", { noremap = true, desc = "Split window below" })
  map("n", "<leader>|", "<cmd>vsplit<cr>", { noremap = true, desc = "Split window right" })

  -- Delete LSP keymaps
  for _, key in ipairs({ "gra", "gri", "grn", "grr", "grt", "gO", "grx" }) do
    pcall(vim.keymap.del, "n", key)
  end

  -- Search and replace in line
  map("n", "<leader>fs", ":%s/", { noremap = true, silent = true, desc = "Search and replace" })

  -- Search only in visual selection using the %V atom
  map("v", "<leader>fs", ":s/\\%V", { noremap = true, silent = true, desc = "Search and replace in selection" })

  -- Quickfix & Loclist
  map("n", "<leader>bq", "<cmd>copen<cr>", { noremap = true, silent = true, desc = "Quickfix" })
  map("n", "<leader>bl", "<cmd>lopen<cr>", { noremap = true, silent = true, desc = "Loclist" })

  -- Git
  map({ "n", "v" }, "<leader>gB", function()
    require("utils.gitbrowse").open()
  end, { desc = "Git Browse" })
  -- Turn a unix timestamp into "N days/months/years ago"
  local function time_ago(epoch)
    local units = { { 31536000, "year" }, { 2592000, "month" }, { 86400, "day" }, { 3600, "hour" }, { 60, "minute" } }
    local diff = os.time() - epoch
    for _, unit in ipairs(units) do
      local secs, name = unit[1], unit[2]
      if diff >= secs then
        local n = math.floor(diff / secs)
        return n .. " " .. name .. (n > 1 and "s" or "") .. " ago"
      end
    end
    return "just now"
  end

  map({ "n", "v" }, "<leader>gs", function()
    local line = vim.fn.line(".")
    local file = vim.fn.expand("%") --[[@as string]]
    ---@type string[]
    local cmd = { "git", "blame", "--porcelain", "-L", line .. "," .. line, file }
    local out = vim.fn.systemlist(cmd)
    local info = {}
    for _, l in ipairs(out) do
      local key, val = l:match("^(%a[%a%-]*)%s+(.*)$")
      if key then
        info[key] = val
      end
    end
    local when = info["author-time"] and time_ago(tonumber(info["author-time"])) or "unknown time"
    vim.notify(
      string.format("%s (%s)\n%s", info.author or "unknown", when, info.summary or ""),
      vim.log.levels.INFO,
      { title = "Git Blame" }
    )
  end, { desc = "Git Blame (current line)" })

  -- Notification
  map("n", "<leader>n", "<cmd>messages<cr>", { desc = "Show Notification" })
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

require("vscode-keymaps")
