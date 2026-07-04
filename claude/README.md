# Claude Code config

`settings.json` is git-tracked and syncs on clone. MCP servers live in the
un-tracked `.claude.json` (user scope) --- re-add them manually on a new
machine:

```bash
claude mcp add-json -s user bigquery '{"command":"uvx","args":["mcp-server-bigquery","--project","tvlk-shared-bq-dev","--location","${BIGQUERY_LOCATION}"]}'
claude mcp add-json -s user sequential-thinking '{"command":"npx","args":["-y","@modelcontextprotocol/server-sequential-thinking"]}'
claude mcp add -s user -t http gh_grep https://mcp.grep.app
claude mcp add-json -s user jupyter '{"command":"uvx","args":["jupyter-mcp-server@latest"],"env":{"JUPYTER_URL":"${JUPYTER_URL}","JUPYTER_TOKEN":"${JUPYTER_TOKEN}","ALLOW_IMG_OUTPUT":"true"}}'
claude mcp add-json -s user sqz '{"command":"sqz-mcp","args":["--transport","stdio"]}'
```

Required env vars (set in shell): `BIGQUERY_LOCATION`, `JUPYTER_URL`,
`JUPYTER_TOKEN`. `CLAUDE_CONFIG_DIR=$HOME/.config/claude` is set in `.zshrc`.
