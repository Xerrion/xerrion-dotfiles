# xerrion-dotfiles

Cross-platform dotfiles managed by [chezmoi](https://chezmoi.io/).

**Status:** 🚧 Under construction. Migration from [xerrion-zsh-custom](https://github.com/Xerrion/xerrion-zsh-custom) in progress.

## Bootstrap

_Coming soon._ Target commands:

```bash
# macOS
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply Xerrion/xerrion-dotfiles

# Windows (PowerShell)
'&{$(irm ''https://get.chezmoi.io/ps1'')} -b $HOME/bin init --apply Xerrion/xerrion-dotfiles' | iex
```

## Layout

- `home/` — chezmoi source state (referenced via `.chezmoiroot`)
- `home/.chezmoidata/packages.yaml` — single source of truth for all packages across macOS and Windows
- `home/.chezmoiexternal.toml` — git repos pulled in as externals (replaces submodules)
- `home/.chezmoiscripts/` — install scripts: `run_once_*`, `run_onchange_*`
- `home/dot_*` — dotfiles (templated `.tmpl` for OS/arch-aware content)
