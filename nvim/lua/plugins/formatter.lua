return { {
    "stevearc/conform.nvim",
    vscode = false,
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>cf",
            function()
                require("conform").format({ async = true, lsp_format = "fallback" })
            end,
            mode = "",
            desc = "Format buffer",
        },
    },
    opts = {},
    config = function(_, opts)
        opts.formatters_by_ft = {}
        opts.formatters = {}

        -- markdown
        local md_ft = { "quarto", "markdown" }
        for _, ft in ipairs(md_ft) do
            opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
            table.insert(opts.formatters_by_ft[ft], "injected")
        end

        -- python
        for _, ft in ipairs({ "python" }) do
            opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
            table.insert(opts.formatters_by_ft[ft], "ruff_format")
        end


        -- sql
        local sql_ft = { "sql", "mysql", "plsql" }
        opts.formatters_by_ft.dawet_lint = {
            command = "dawet",
            args = function()
                return { "lint", "-m", vim.fn.expand("%:t:r") }
            end,
            cwd = require("conform.util").root_file({ "dawet_project.yml" }),
            require_cwd = true,
        }
        for _, ft in ipairs(sql_ft) do
            opts.formatters_by_ft[ft] = { "sqlfmt" }
            -- conform.formatters_by_ft[ft] = { "dawet_lint" } -- slow
        end

        -- Customize the "injected" formatter
        opts.formatters.injected = {
            -- Set the options field
            options = {
                -- Set to true to ignore errors
                ignore_errors = true,
                -- Map of treesitter language to file extension
                -- A temporary file name with this extension will be generated during formatting
                -- because some formatters care about the filename.
                lang_to_ext = {
                    bash = "sh",
                    c_sharp = "cs",
                    elixir = "exs",
                    javascript = "js",
                    julia = "jl",
                    latex = "tex",
                    markdown = "md",
                    python = "py",
                    ruby = "rb",
                    rust = "rs",
                    teal = "tl",
                    r = "r",
                    typescript = "ts",
                },
                -- Map of treesitter language to formatters to use
                -- (defaults to the value from formatters_by_ft)
                lang_to_formatters = {},
            },
        }
    end
} }
