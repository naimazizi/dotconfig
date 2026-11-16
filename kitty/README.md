# Remote Vim and Zsh

From Kitty, connect using an existing SSH alias:

```sh
kitten ssh your-host
```

Zsh already aliases `ssh` to `kitten ssh` when running in Kitty.
Ordinary `command ssh` bypasses this setup.
The SSH kitten requires Kitty; it is not a general SSH replacement for other terminals.

`ssh.conf` applies to every Kitten SSH connection.
Narrow `hostname *` before use if only some hosts should receive these configs.
Only connect to trusted hosts.

## What gets copied

An explicit list copies the Zsh config, its `fzg` helper, Vim config, CoC settings, Panache config, and Starship config into `~/.local/share/kitty-dotfiles/` on the remote.
Those managed copies refresh on every connection.
Existing remote `.zshrc`, `.vimrc`, and `.config` files are not overwritten.
Credentials, histories, plugin caches, and local binaries are not copied.

The session uses Zsh and sets `EDITOR`/`VISUAL` to Vim.
Vim reads CoC and Panache settings from the copied directory.
Plugin managers still use their normal remote data directories, including `~/.vim` and `~/.local/share/zinit`.

## Remote prerequisites

Config transfer does not install system packages.
The remote needs Zsh, Git, curl, tar, Vim with job/channel/terminal support, and Node.js for CoC.
Vim plugin build hooks also need make and a C compiler.
Zinit and Vim-Plug download their plugins from the remote, so network access is required.

On first use, install Vim plugins, then restart Vim:

```sh
vim +PlugInstall
```

The initial Vim launch can report missing theme/plugins until installation finishes.
Zsh bootstraps Zinit and its configured plugins on first startup.
Optional lsd, fd, zoxide, and Atuin integrations activate only when those commands are installed; the remaining convenience aliases still need their corresponding tools.

CoC language tools must be installed for the remote OS and available on its `PATH`: `pyrefly`, `ruff`, `emmylua_ls`, `stylua`, TypeScript 7+ `tsc`, `yaml-language-server`, `oxfmt`, `shuck`, and `panache`.
Markdown code-block formatting can require additional tools from `panache/config.toml`.
Do not copy macOS binaries to Linux.

After tools are installed, use `Space cf` in Vim to format.
Use `:CocInfo` to diagnose missing servers.
