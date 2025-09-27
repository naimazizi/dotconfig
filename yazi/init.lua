-- DuckDB plugin configuration
require("duckdb"):setup()

require("copy-file-contents"):setup({
	append_char = "\n",
	notification = true,
})
