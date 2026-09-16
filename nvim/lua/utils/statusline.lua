-- Content builders for `mini.statusline` (see `plugins/mini.lua`).
local M = {}

local function ministatusline()
  return require("mini.statusline")
end

-- Mode section, showing "Recording @<register>" while recording a macro
-- (mini.statusline has no built-in equivalent).
local function mode_section()
  local reg = vim.fn.reg_recording()
  if reg ~= "" then
    return "Recording @" .. reg, "MiniStatuslineModeOther"
  end
  return ministatusline().section_mode({ trunc_width = 120 })
end

local function navic_section()
  local ok, navic = pcall(require, "nvim-navic")
  if not ok or not navic.is_available() then
    return ""
  end
  return navic.get_location()
end

local function overseer_section()
  if package.loaded["overseer"] == nil then
    return ""
  end
  local icons = { FAILURE = "󰅚", CANCELED = "", SUCCESS = "󰄴", RUNNING = "󰑮" }
  local counts = {}
  for _, task in ipairs(require("overseer").list_tasks()) do
    counts[task.status] = (counts[task.status] or 0) + 1
  end
  local parts = {}
  for _, status in ipairs({ "FAILURE", "RUNNING", "SUCCESS", "CANCELED" }) do
    if counts[status] then
      table.insert(parts, icons[status] .. counts[status])
    end
  end
  return table.concat(parts, " ")
end

-- Attached LSP client names (original lualine `lsp_status` component
-- showed names, not mini.statusline's default "+" count symbols).
local function lsp_section(args)
  if ministatusline().is_truncated(args.trunc_width) then
    return ""
  end
  local names = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    table.insert(names, client.name)
  end
  if #names == 0 then
    return ""
  end
  return " " .. table.concat(names, " ")
end

local function opencode_section()
  if package.loaded["opencode"] == nil then
    return ""
  end
  return require("opencode").statusline()
end

local function venv_section()
  if package.loaded["venv-selector"] == nil then
    return ""
  end
  local venv_path = require("venv-selector").venv()
  if not venv_path or venv_path == "" then
    return ""
  end
  return "󱔎 " .. vim.fn.fnamemodify(venv_path, ":t")
end

function M.active()
  local mini = ministatusline()
  local mode, mode_hl = mode_section()
  local git = mini.section_git({ trunc_width = 40 })
  local diff = mini.section_diff({ trunc_width = 75 })
  local diagnostics = mini.section_diagnostics({ trunc_width = 75 })
  local filename = mini.section_filename({ trunc_width = 140 })
  local fileinfo = mini.section_fileinfo({ trunc_width = 120 })
  local lsp = lsp_section({ trunc_width = 75 })
  local location = mini.section_location({ trunc_width = 75 })

  return mini.combine_groups({
    { hl = mode_hl, strings = { mode } },
    { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, overseer_section() } },
    "%<",
    { hl = "MiniStatuslineFilename", strings = { filename, navic_section() } },
    "%=",
    { hl = "MiniStatuslineFileinfo", strings = { lsp, opencode_section(), venv_section(), fileinfo } },
    { hl = mode_hl, strings = { "%p%%", location } },
  })
end

function M.inactive()
  return "%#MiniStatuslineInactive#%F%="
end

-- Attach `nvim-navic` to LSP clients that support document symbols, so
-- `navic_section()` above has breadcrumbs to show.
function M.attach_navic()
  vim.g.navic_silence = true
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.server_capabilities and client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, args.buf)
      end
    end,
  })
end

return M
