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
  require("mini.sessions").write()
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
  require("mini.sessions").delete(name, { force = false })
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
map("n", "<leader>cl", "<cmd>CocList diagnostics<cr>", { silent = true, desc = "Diagnostics (CocList)" })
map("n", "<leader>cq", vim.diagnostic.setloclist, { silent = true, desc = "Quickfix diagnostics" })

-- Quickfix / location list (LazyVim-ish)
map("n", "<leader>xx", "<cmd>CocList diagnostics<cr>", { silent = true, desc = "Diagnostics" })
map("n", "<leader>xl", "<cmd>lopen<cr>", { silent = true, desc = "Location list" })
map("n", "[q", "<cmd>cprev<cr>", { silent = true, desc = "Prev quickfix" })
map("n", "]q", "<cmd>cnext<cr>", { silent = true, desc = "Next quickfix" })
map("n", "[l", "<cmd>lprev<cr>", { silent = true, desc = "Prev location" })
map("n", "]l", "<cmd>lnext<cr>", { silent = true, desc = "Next location" })

-- Files / finders
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { silent = true, desc = "Explorer" })

-- LazyVim-ish (fzf-lua)
map("n", "<leader>ff", function()
  require("fzf-lua").files()
end, { silent = true, desc = "Find files" })
map("n", "<leader>fF", function()
  require("fzf-lua").files({ cwd = vim.fn.expand("%:p:h") })
end, { silent = true, desc = "Find files (cwd)" })
map("n", "<leader>fg", function()
  require("fzf-lua").live_grep()
end, { silent = true, desc = "Grep" })

-- Search (LazyVim-ish)
map("n", "<leader>/", function()
  require("fzf-lua").live_grep({ cwd = vim.fn.getcwd() })
end, { silent = true, desc = "Grep (cwd)" })

-- Search/Replace (grug-far)
map("n", "<leader>sr", function()
  require("grug-far").open()
end, { silent = true, desc = "Search/Replace (grug-far)" })
map("n", "<leader>fb", function()
  require("fzf-lua").buffers()
end, { silent = true, desc = "Buffers" })
map("n", "<leader>fr", function()
  require("fzf-lua").oldfiles()
end, { silent = true, desc = "Recent" })
map("n", "<leader>fh", function()
  require("fzf-lua").help_tags()
end, { silent = true, desc = "Help" })

-- Alternative fast file picker (fff.nvim)
map("n", "<leader><space>", function()
  require("fff").find_files()
end, { silent = true, desc = "Find files (fff)" })

-- Git (mini)
map("n", "<leader>gg", "<cmd>lua MiniGit.show_at_cursor()<cr>", { silent = true, desc = "Git show at cursor" })
map("n", "<leader>go", "<cmd>lua MiniDiff.toggle_overlay()<cr>", { silent = true, desc = "Git overlay" })

-- Coc (as close to LazyVim bindings as possible)
map("n", "[d", "<Plug>(coc-diagnostic-prev)", { silent = true, desc = "Prev diagnostic (coc)" })
map("n", "]d", "<Plug>(coc-diagnostic-next)", { silent = true, desc = "Next diagnostic (coc)" })

-- GoTo code navigation (LazyVim defaults)
map("n", "gd", "<Plug>(coc-definition)", { silent = true, desc = "Goto definition" })
map("n", "gr", "<Plug>(coc-references)", { silent = true, desc = "References" })

-- Next/Prev reference / section
-- Order: CocNext/CocPrev -> built-in [[/]]
map("n", "]]", function()
	local ok = pcall(vim.cmd, "silent CocNext")
	if not ok then
		vim.cmd("normal! ]]")
	end
end, { silent = true, desc = "Next reference/section" })

map("n", "[[", function()
	local ok = pcall(vim.cmd, "silent CocPrev")
	if not ok then
		vim.cmd("normal! [[")
	end
end, { silent = true, desc = "Prev reference/section" })
map("n", "gi", "<Plug>(coc-implementation)", { silent = true, desc = "Goto implementation" })
map("n", "gy", "<Plug>(coc-type-definition)", { silent = true, desc = "Goto type definition" })

-- Hover docs (LazyVim: K)
function _G.show_docs()
  local cw = vim.fn.expand("<cword>")
  if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
    vim.api.nvim_command("h " .. cw)
  elseif vim.api.nvim_eval("coc#rpc#ready()") == 1 then
    vim.fn.CocActionAsync("doHover")
  else
    vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
  end
end
map("n", "K", "<cmd>lua _G.show_docs()<cr>", { silent = true, desc = "Hover" })

-- LazyVim-style leader bindings
map("n", "<leader>cr", "<Plug>(coc-rename)", { silent = true, desc = "Rename" })
map("n", "<leader>ca", "<Plug>(coc-codeaction-cursor)", { silent = true, nowait = true, desc = "Code action" })
map("x", "<leader>ca", "<Plug>(coc-codeaction-selected)", { silent = true, nowait = true, desc = "Code action" })
map("n", "<leader>cA", "<Plug>(coc-codeaction-source)", { silent = true, nowait = true, desc = "Source action" })

-- Quickfix / preferred fixes (LazyVim-ish)
map("n", "<leader>cF", "<Plug>(coc-fix-current)", { silent = true, nowait = true, desc = "Fix current" })

-- Refactor
map("n", "<leader>cR", "<Plug>(coc-codeaction-refactor)", { silent = true, desc = "Refactor" })
map("x", "<leader>cR", "<Plug>(coc-codeaction-refactor-selected)", { silent = true, desc = "Refactor selection" })

-- CodeLens
map("n", "<leader>cl", "<Plug>(coc-codelens-action)", { silent = true, nowait = true, desc = "CodeLens" })

-- Coc completion/snippets
function _G.check_back_space()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

local coc_expr_opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
map(
  "i",
  "<Tab>",
  'coc#pum#visible() ? coc#pum#confirm() : v:lua.check_back_space() ? "<Tab>" : coc#refresh()',
  coc_expr_opts
)
map("i", "<S-Tab>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], coc_expr_opts)
map("i", "<C-j>", "<Plug>(coc-snippets-expand-jump)", { silent = true, desc = "Snippet expand/jump" })
map("i", "<C-k>", "<Plug>(coc-snippets-expand-jump-backward)", { silent = true, desc = "Snippet jump backward" })
map("i", "<C-Space>", "coc#refresh()", { silent = true, expr = true, desc = "Completion" })

-- Map function/class textobjects
local coc_nowait = { silent = true, nowait = true }
map("x", "if", "<Plug>(coc-funcobj-i)", coc_nowait)
map("o", "if", "<Plug>(coc-funcobj-i)", coc_nowait)
map("x", "af", "<Plug>(coc-funcobj-a)", coc_nowait)
map("o", "af", "<Plug>(coc-funcobj-a)", coc_nowait)
map("x", "ic", "<Plug>(coc-classobj-i)", coc_nowait)
map("o", "ic", "<Plug>(coc-classobj-i)", coc_nowait)
map("x", "ac", "<Plug>(coc-classobj-a)", coc_nowait)
map("o", "ac", "<Plug>(coc-classobj-a)", coc_nowait)

-- Scroll Coc floating windows
local coc_float_opts = { silent = true, nowait = true, expr = true }
map("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', coc_float_opts)
map("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', coc_float_opts)
map("i", "<C-f>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', coc_float_opts)
map("i", "<C-b>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', coc_float_opts)
map("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', coc_float_opts)
map("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', coc_float_opts)

-- Selection range (keep your save binding on <C-s>)
map("n", "<leader>cs", "<Plug>(coc-range-select)", { silent = true, desc = "Selection range" })
map("x", "<leader>cs", "<Plug>(coc-range-select)", { silent = true, desc = "Selection range" })

-- Commands
vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", { nargs = "?" })
vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

-- Statusline integration
vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")

-- CocList (mapped to LazyVim's <leader>x* where sensible)
map("n", "<leader>xx", ":<C-u>CocList diagnostics<cr>", { silent = true, nowait = true, desc = "Diagnostics" })
map("n", "<leader>ce", ":<C-u>CocList extensions<cr>", { silent = true, nowait = true, desc = "Extensions" })
map("n", "<leader>cc", ":<C-u>CocList commands<cr>", { silent = true, nowait = true, desc = "Coc commands" })
map("n", "<leader>co", ":<C-u>CocList outline<cr>", { silent = true, nowait = true, desc = "Outline" })
map("n", "<leader>cS", ":<C-u>CocList -I symbols<cr>", { silent = true, nowait = true, desc = "Workspace symbols" })
map("n", "<leader>cj", ":<C-u>CocNext<cr>", { silent = true, nowait = true, desc = "Coc next" })
map("n", "<leader>ck", ":<C-u>CocPrev<cr>", { silent = true, nowait = true, desc = "Coc prev" })
map("n", "<leader>cp", ":<C-u>CocListResume<cr>", { silent = true, nowait = true, desc = "Coc resume" })

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

-- Tests (neotest)
map("n", "<leader>tt", function()
  require("neotest").run.run()
end, { desc = "Run nearest test" })
map("n", "<leader>tT", function()
  require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Run file tests" })
map("n", "<leader>to", function()
  require("neotest").output.open({ enter = true })
end, { desc = "Test output" })
map("n", "<leader>ts", function()
  require("neotest").summary.toggle()
end, { desc = "Test summary" })
