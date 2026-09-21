local M = {}

-- Base mini.clue setup: triggers, clue groups/descriptions and window opts.
function M.setup()
  local miniclue = require("mini.clue")

  miniclue.setup({
    triggers = {
      { mode = "n", keys = "<leader>" },
      { mode = "x", keys = "<leader>" },
      { mode = "n", keys = "<localleader>" },
      { mode = "x", keys = "<localleader>" },
      { mode = "n", keys = "g" },
      { mode = "x", keys = "g" },
      { mode = "o", keys = "g" },
      { mode = "n", keys = "z" },
      { mode = "x", keys = "z" },
      { mode = "n", keys = "[" },
      { mode = "n", keys = "]" },
      { mode = { "n", "x" }, keys = "'" },
      { mode = { "n", "x" }, keys = "`" },
      { mode = { "n", "x" }, keys = '"' },
      { mode = "i", keys = "<C-r>" },
      { mode = "c", keys = "<C-r>" },
      { mode = "n", keys = "<C-w>" },
      { mode = "i", keys = "<C-x>" },
      -- mini.ai textobjects (op-pending "a"/"i" prefixes, no real submapping)
      { mode = { "o", "x" }, keys = "a" },
      { mode = { "o", "x" }, keys = "i" },
    },
    clues = {
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.square_brackets(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),

      { mode = { "n", "x" }, keys = "<leader>a", desc = "+AI" },
      { mode = "n", keys = "<leader>b", desc = "+buffer" },
      { mode = { "n", "x" }, keys = "<leader>c", desc = "+code" },
      { mode = "n", keys = "<leader>d", desc = "+debug" },
      { mode = "n", keys = "<leader>f", desc = "+find" },
      { mode = { "n", "x" }, keys = "<leader>g", desc = "+git" },
      { mode = { "n", "x" }, keys = "<leader>s", desc = "+search" },
      { mode = "n", keys = "<leader>q", desc = "+quit/session" },
      { mode = "n", keys = "<leader>t", desc = "+test" },
      { mode = "n", keys = "<leader>u", desc = "+ui" },
      { mode = "n", keys = "<leader>o", desc = "+overseer" },
      -- additional plugin
      { mode = "n", keys = "<localleader>r", desc = "+REPL" },
      { mode = "n", keys = "<localleader>s", desc = "+Quarto" },
      { mode = "n", keys = "<localleader>c", desc = "+Curl (hurl)" },
      { mode = { "n", "x" }, keys = "gs", desc = "+Surround" },
      { mode = "n", keys = "<leader>dD", desc = "+DAP ft-specific" },
      { mode = "n", keys = "<leader>h", desc = "+Haunting Notes" },
      { mode = "n", keys = "<leader>m", desc = "+notes (iwe)" },
      { mode = "n", keys = "<leader>mp", desc = "+preview" },

      { mode = "n", keys = "[C", desc = "Prev cursor" },
      { mode = "n", keys = "]C", desc = "Next cursor" },
    },
    window = { delay = 100 },
  })

  -- Triggers are buffer-local mappings and must stay the most recent one to
  -- work (see `:h MiniClue-key-query-process` caveats). Plugins that add
  -- their own buffer-local mappings on these events (LSP keymaps, treesitter
  -- textobjects, illuminate's `]]`/`[[`, ...) would otherwise silently break
  -- the `g`/`[`/`]`/`<leader>` triggers for that buffer.
  vim.api.nvim_create_autocmd({ "LspAttach", "FileType" }, {
    callback = function()
      vim.schedule(miniclue.ensure_buf_triggers)
    end,
  })
end

-- Register clue descriptions for mini.ai's op-pending "a"/"i" textobjects
-- (e.g. `af`, `if`, `an(`, ...). These have no real mapping to attach a
-- `desc` to, so they must be added as standalone clues.
function M.ai_clues(opts)
  if vim.g.vscode then
    return
  end

  opts = opts or {}
  local objects = {
    { " ", desc = "whitespace" },
    { '"', desc = '" string' },
    { "'", desc = "' string" },
    { "(", desc = "() block" },
    { ")", desc = "() block with ws" },
    { "<", desc = "<> block" },
    { ">", desc = "<> block with ws" },
    { "?", desc = "user prompt" },
    { "U", desc = "use/call without dot" },
    { "[", desc = "[] block" },
    { "]", desc = "[] block with ws" },
    { "_", desc = "underscore" },
    { "`", desc = "` string" },
    { "a", desc = "argument" },
    { "b", desc = ")]} block" },
    { "c", desc = "class" },
    { "d", desc = "digit(s)" },
    { "e", desc = "CamelCase / snake_case" },
    { "f", desc = "function" },
    { "i", desc = "indent" },
    { "o", desc = "block, conditional, loop" },
    { "q", desc = "quote `\"'" },
    { "t", desc = "tag" },
    { "u", desc = "use/call" },
    { "{", desc = "{} block" },
    { "}", desc = "{} with ws" },
  }

  ---@type table[]
  local clues = {}
  ---@type table<string, string>
  local mappings = vim.tbl_extend("force", {}, {
    around = "a",
    inside = "i",
    around_next = "an",
    inside_next = "in",
    around_last = "al",
    inside_last = "il",
  }, opts.mappings or {})
  mappings.goto_left = nil
  mappings.goto_right = nil

  for name, prefix in pairs(mappings) do
    name = name:gsub("^around_", ""):gsub("^inside_", "")
    clues[#clues + 1] = { mode = { "o", "x" }, keys = prefix, desc = "+" .. name }
    for _, obj in ipairs(objects) do
      local desc = obj.desc
      if prefix:sub(1, 1) == "i" then
        desc = desc:gsub(" with ws", "")
      end
      clues[#clues + 1] = { mode = { "o", "x" }, keys = prefix .. obj[1], desc = desc }
    end
  end
  -- mini.clue has no incremental "add"; re-setup with existing config plus these clues
  local miniclue = require("mini.clue")
  local config = miniclue.config
  miniclue.setup({
    triggers = config.triggers,
    window = config.window,
    clues = vim.list_extend(vim.deepcopy(config.clues), clues),
  })
end

return M
