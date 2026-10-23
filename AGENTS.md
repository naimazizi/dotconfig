# Repository guide for agents

## Start here

This is a personal dotfiles repository, not an application or monorepo.
It normally lives at `~/.config`; edits can affect running tools immediately.
The environment includes macOS and Linux/Homebrew configurations.

1. Run `git status --short` and inspect the relevant diff before editing.
   Preserve existing user changes; do not reset, overwrite, or broadly reformat them.
2. Read `README.md` for installation and tool dependencies, then the target tool's entry point below.
   Inspect actual code rather than assuming the README or an old shell alias describes current behavior.
3. Limit searches to tracked files or the relevant tool directory.
   This live config directory also contains ignored credentials and runtime data.
   Do not inspect or copy authentication files, tokens, histories, or private data into output, documentation, or commits.
4. Make the smallest complete change, use existing patterns, and validate only the affected behavior.
   Report checks not run and material limitations.

## Where things live

- **Neovim:** `nvim/init.lua` and `nvim/lua/{options,keymaps,autocmds,plugins}.lua`.
- **Neovim plugins:** `nvim/lua/plugins/*.lua`, language modules in `nvim/lua/plugins/lang/`, local helpers in `nvim/lua/utils/`.
- **VSCode Neovim:** `nvim/lua/vscode-config.lua` for commands, keymaps, and UI.
- **VSCodium profile:** `vscodium/profiles/main/data/` contains settings, macOS keybindings, and extensions; `vscodium/profiles/main/.sync.yml` selects synchronized resources.
- **Other editors:** `helix/{config,languages}.toml`, `vim/.vimrc`, `zed/{settings,keymap}.json`.
- **Shells:** `zsh/.zshrc` (Zinit), `zsh/.zfunc/`; `fish/config.fish`, `fish/fish_plugins` (Fisher), `fish/functions/`, `fish/conf.d/`.
- **Terminals:** `wezterm/wezterm.lua` loads `wezterm/config/*.lua`; `ghostty/config`, `kitty/kitty.conf`, `foot/foot.ini`, `neovide/config.toml`.
- **Multiplexers:** `tmux/tmux.conf`, `tmuxinator/`, `zellij/config.kdl`.
- **CLI tools:** `yazi/`, `lazygit/config.yml`, `gitui/`, `atuin/`, `starship.toml`.
- **Coding agents:** `opencode/` and `pi/`; read `opencode/AGENTS.md` before changes under `opencode/`.
- **Formatting:** `.pre-commit-config.yaml`, `.oxfmtrc.json`, `.typos.toml`, `panache/config.toml`, tool-specific StyLua configs.
- **Setup/helpers:** `install.sh`, `nvim-remote.sh`, `skim_search.sh`, `lima-box.yaml`.

Prefer editing plugin manifests/configuration over installed plugin copies.
For example, Fish includes third-party function/completion files, while Yazi lists dependencies in `yazi/plugins.txt` and ignores downloaded plugins.

## Neovim architecture and conventions

- Requires **Neovim >= 0.13**, checked in `nvim/init.lua`.
  Bob manages local installations; verify the actual executable/version before testing.
- Uses built-in **`vim.pack`**, not Lazy.nvim. Shell `nvim_update` aliases still mention `Lazy! sync`; do not use them as the update procedure.
  Package updates are explicit operations via `vim.pack.update()`, not tests.
- `init.lua` defines global `Config`, then loads `options`, `keymaps`, `autocmds`, `plugins`, and finally `vscode-config` when `vim.g.vscode` is set.
- Each plugin module declares its own packages with `vim.pack.add({ Config.gh("owner/repo") })` and owns its setup/keymaps.
  `plugins.lua` discovers `lua/plugins/**/*.lua` automatically.
  Its priority modules are `mini`, `mason`, and `overseer`; preserve runtime dependencies.
- Use `Config.now`, `Config.later`, `Config.on_event`, or `Config.on_filetype` for setup timing, following nearby code.
  These wrap `mini.misc.safely`.
  `Config.disabled` does not execute its callback; keep disabled package declarations inside it so they are not installed accidentally.
- Register build hooks with `Config.on_packchanged` **before** the package is added.
  Package declarations are recorded for the `:PackClean` command.
  The generated `nvim-pack-lock.json` is intentionally ignored.
- Most UI/LSP/plugin modules return early under `vim.g.vscode`.
  Keep standalone-only changes behind that guard.
  VSCode renders its own UI; use the existing `require("vscode")` API in `vscode-config.lua` for editor commands and visible UI settings rather than relying on Neovim options.
- `<Space>` is the leader; `\` is the local leader.
  Use `vim.keymap.set` with descriptive `desc` values.
  Check global, plugin, buffer-local, and VSCode mappings before changing a key.
  Mini Clue support lives in `nvim/lua/utils/mini-clue.lua` and `nvim/lua/plugins/mini.lua`.
- Lua formatting is two spaces, 120 columns under `nvim/stylua.toml`.
  WezTerm has separate formatter settings; preserve each tool's style.
  `nvim/.emmyrc.json` configures EmmyLua LS and installed plugin type libraries.
- Runtime formatting uses Conform in `nvim/lua/plugins/formatter.lua`.
  `nvim/lua/plugins/test.lua` configures Neotest for projects opened in the editor; it is **not** a test suite for this dotfiles repository.

## Safe validation

There is no repository-wide application build or dedicated automated test suite.
Run commands from the repository root unless stated otherwise.

- Review whitespace with `git diff --check` (and inspect `git diff`).
- Do not manually hard-wrap Markdown or insert line breaks for formatting; write the content and let Panache handle formatting with `panache --config panache/config.toml format <changed-files>`.
- Check Lua formatting without rewriting files: `stylua --check --config-path nvim/stylua.toml nvim/lua/path/to/file.lua`.
- Parse a Lua file without loading the full editor configuration: `nvim --headless -u NONE '+lua assert(loadfile("nvim/lua/path/to/file.lua"))' +qa`.
  This checks syntax only; for changed callbacks/branches, add a small focused assertion-based check, mocking host APIs when needed.
- Check Bash scripts with `bash -n path/to/script.sh`, Zsh with `zsh -n zsh/.zshrc`, and Fish with `fish --no-execute path/to/file.fish`.
  Syntax checks do not require sourcing shell startup files.
- Check Markdown with `panache --config panache/config.toml format --check AGENTS.md` and `panache --config panache/config.toml lint AGENTS.md`.
- `.pre-commit-config.yaml` defines the broader checks.
  If installed, use `pre-commit run --files <changed-files>`, not an unrequested whole-repo run.
  Several hooks **rewrite files** and require external executables or downloads; inspect the resulting diff.
  Avoid running them on unrelated user work.
- Full Neovim startup can install plugins, run native builds, and load external integrations.
  Do not use it as a harmless syntax check.
  Test interactive behavior in the relevant host when available; mocked tests do not establish that VSCode, terminal key delivery, or plugin windows behave correctly.

## Operational boundaries

- The root `.gitignore` ignores everything by default, then allows specific files/directories.
  When adding a new root file or tool directory, check `git check-ignore -v <path>` and add a narrow exception if needed.
  Do not force-add ignored runtime state or secrets.
- Do not run `install.sh` to validate changes.
  It is a Codespaces bootstrap that moves existing configs, replaces symlinks, and installs Homebrew/tools.
  Running it from an already-live `~/.config` checkout is especially unsafe.
- Do not source shell startup files or execute remote/VM helper scripts as tests; they can download plugins, change sessions, or connect to other hosts.
- Ask before adding dependencies when tradeoffs matter, installing/updating packages, deleting configs, or changing shared machine settings.
  Surface actionable errors; do not add silent fallback behavior.
- Keep this guide focused on durable structure and verified commands.
  Do not turn it into a session log or duplicate fast-changing plugin settings.
