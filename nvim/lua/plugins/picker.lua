return {
  {
    "dmtrKovalenko/fff",
    lazy = false,
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    opts = {
      prompt = "",
      layout = {
        height = 0.6,
        width = 0.6,
        prompt_position = "top",
        preview_position = "bottom",
        preview_size = 0.5,
        flex = { size = 130, wrap = "top" },
        min_list_height = 10,
        show_scrollbar = true,
        path_shorten_strategy = "middle_number", -- 'middle' | 'middle_number' | 'end' | 'start'
        anchor = "top",
        show_path_first = false, -- true renders results as `path/to/file` instead of `file path/to`
      },
      grep = {
        max_file_size = 10 * 1024 * 1024,
        max_matches_per_file = 100,
        smart_case = true,
        time_budget_ms = 150,
        modes = { "fuzzy", "plain", "regex" },
        trim_whitespace = false,
        enable_filename_constraint = false, -- treat filename-like tokens (e.g. `score.rs`) in a grep query as a file-path filter scoping the search; off = searched as literal text
        location_format = ":%d:%d", -- printf format for line:col prefix in grep results, e.g. ':%d' for line-only
      },
    },
    keys = {
      {
        "<leader><leader>",
        function()
          require("fff").find_files({ resume = true })
        end,
        desc = "Find files",
      },
      {
        "<leader>/",
        function()
          require("fff").live_grep({ resume = true })
        end,
        desc = "Live Grep",
      },
      {
        "<leader>fg",
        function()
          require("fff").live_grep({ resume = true })
        end,
        desc = "Live Grep",
      },
      {
        "<leader>sw",
        function()
          require("fff").live_grep_under_cursor()
        end,
        mode = { "n", "x" },
        desc = "Search current word / selection",
      },
    },
  },
}
