# xerrion-dotfiles

Cross-platform dotfiles for macOS and Windows, managed by [chezmoi](https://chezmoi.io/).

A single source of truth for shell configuration, package manifests, editor setup, and OS defaults. One `chezmoi apply` bootstraps a fresh machine.

## Overview

- Cross-platform: macOS (zsh + Homebrew) and Windows (PowerShell 7 + scoop/winget).
- Secrets are resolved at apply time via the 1Password CLI. Nothing sensitive is stored in the repo.
- Packages are declared in a single YAML manifest and installed idempotently on each OS.
- Git repos previously tracked as submodules are now pulled as chezmoi externals.

## Prerequisites

### macOS

- Xcode Command Line Tools: `xcode-select --install`
- [1Password CLI](https://developer.1password.com/docs/cli/get-started/) installed and signed in: `op signin`

The rest (Homebrew, zsh plugins, oh-my-zsh, rustup, bun) is installed by the bootstrap scripts.

### Windows

- PowerShell 7+ (`pwsh`)
- Git for Windows
- [1Password CLI](https://developer.1password.com/docs/cli/get-started/) installed and signed in

The rest (scoop, winget packages, PSModules, rustup) is installed by the bootstrap scripts.

## Bootstrap

One-liners to bootstrap a fresh machine. Both commands install chezmoi, clone this repo, and run `chezmoi apply`.

### macOS

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply Xerrion/xerrion-dotfiles
```

### Windows (PowerShell 7+)

```powershell
iex "&{$(irm 'https://get.chezmoi.io/ps1')} -- init --apply Xerrion/xerrion-dotfiles"
```

On first apply, chezmoi will prompt for `git.name` and `git.email` (see [Customization](#customization)).

## Architecture

### Repository layout

```
.
|-- .chezmoiroot            # points chezmoi at home/
|-- home/                   # chezmoi source state
|   |-- .chezmoi.toml.tmpl      # per-machine config (prompts for git identity)
|   |-- .chezmoidata/           # static data (packages.yaml)
|   |-- .chezmoiexternal.toml   # git repos pulled as externals
|   |-- .chezmoiignore          # OS-gated file exclusions
|   |-- .chezmoiscripts/        # install + sync scripts
|   |-- .chezmoitemplates/      # shared template partials
|   |-- dot_*                   # dotfiles (`.tmpl` for templated content)
|   `-- Documents/              # PowerShell profile, etc.
|-- assets/                 # non-templated assets (iTerm2 colors, etc.)
`-- LICENSE
```

`.chezmoiroot` contains `home`, which tells chezmoi to treat `home/` as the source directory. This keeps CI, docs, and licensing at the repo root instead of polluting `$HOME`.

### Script ordering convention

Scripts in `.chezmoiscripts/` use a numeric prefix to make ordering explicit. Gaps are intentional so new scripts can slot in without renumbering:

| Prefix | Purpose                                          |
| ------ | ------------------------------------------------ |
| 00     | reserved (smoke tests, pre-flight)               |
| 05     | reserved                                         |
| 10     | package manager bootstrap (Homebrew, scoop)      |
| 15     | language toolchains (rustup)                     |
| 20     | shell frameworks (oh-my-zsh, PSModules)          |
| 25     | runtimes (bun)                                   |
| 30     | post-install clones (WoW libs, annotations)      |
| 40     | reserved                                         |
| 50     | reserved                                         |

Combined with chezmoi's `run_once_before_`, `run_once_after_`, and `run_onchange_` prefixes, the full filename reads as an ordering statement: `run_once_before_10-install-homebrew.sh.tmpl`.

### OS gating

OS-specific logic is gated inline with Go templates, not by separate directory trees:

```gotemplate
{{ if eq .chezmoi.os "darwin" }}
# macOS-only
{{ else if eq .chezmoi.os "windows" }}
# Windows-only
{{ end }}
```

For scripts that should only ever run on one OS, the filename carries the guard (`run_onchange_darwin-brew-bundle.sh.tmpl`, `run_onchange_windows-scoop-bundle.ps1.tmpl`) plus an inline `{{ if ne .chezmoi.os "X" }}{{ break }}{{ end }}`-style skip at the top. `.chezmoiignore` additionally excludes files by OS so they never land in the destination.

### Shared templates

`.chezmoitemplates/` holds template partials included with `{{ template "name" . }}`. For example, `brew-shellenv.sh` centralises the Apple-Silicon-vs-Intel Homebrew path logic so it is not duplicated across `.zprofile`, `.zshrc`, and install scripts.

### Package manifest

All packages live in `home/.chezmoidata/packages.yaml`, grouped by OS and package manager (Homebrew formulae, casks, mas, scoop, winget). The `run_onchange_*-bundle` scripts iterate the manifest and install missing packages. Add or remove a package by editing YAML - no script changes required.

### Externals

`home/.chezmoiexternal.toml` pulls third-party git repos (Catppuccin theme, zsh plugins, fast-syntax-highlighting) directly into the destination at apply time. This replaces the submodule-based approach from the predecessor repo. Updates happen with `chezmoi update` instead of `git submodule update --remote`.

## Secrets

Secrets are resolved at template render time via the 1Password CLI using the `onepasswordRead` template function. The CLI must be signed in (`op signin`) before running `chezmoi apply`, otherwise rendering fails.

The following 1Password items must exist for a full apply to succeed:

| Reference                                          | Used in                                 |
| -------------------------------------------------- | --------------------------------------- |
| `op://Private/github-mcp-pat/credential`           | `GITHUB_MCP_TOKEN` env var              |
| `op://Private/sonarqube-token/credential`          | `SONARQUBE_TOKEN` env var               |
| `op://Work/ServiceNow LASN Dev/username`           | `SERVICENOW_MCP_USERNAME` env var       |
| `op://Work/ServiceNow LASN Dev/password`           | `SERVICENOW_MCP_DEV_PASSWORD` env var   |
| `op://Work/ServiceNow LASN Prod/password`          | `SERVICENOW_MCP_PROD_PASSWORD` env var  |

If any are missing or you are not signed in, `chezmoi apply` will halt with a rendering error naming the offending reference.

## Customization

Fork the repo, change `Xerrion/xerrion-dotfiles` in the bootstrap command to your own `user/repo`, and apply. On first apply, `.chezmoi.toml.tmpl` prompts for:

- `git.name` - display name for commits
- `git.email` - email for commits

Answers are persisted to `~/.config/chezmoi/chezmoi.toml` via `promptStringOnce`, so subsequent applies do not re-ask. Change them later by editing that file or running `chezmoi init` again.

Package additions, script tweaks, and OS defaults are straightforward:

- New package: edit `home/.chezmoidata/packages.yaml`, run `chezmoi apply`.
- New dotfile: drop it under `home/` with the `dot_` prefix (e.g. `dot_gitignore_global`). Use `.tmpl` suffix to enable templating.
- New script: add to `home/.chezmoiscripts/` following the numeric-prefix convention above.

## Editor integrations

### Zed (cross-OS)

Zed settings are single-sourced at `home/.chezmoitemplates/zed-settings.json` and deployed to the OS-correct path via two thin template stubs:

- macOS and Linux: `home/dot_config/zed/settings.json.tmpl` -> `~/.config/zed/settings.json`
- Windows: `home/AppData/Roaming/Zed/settings.json.tmpl` -> `%APPDATA%\Zed\settings.json`

Both stubs include the shared body with `{{ template "zed-settings.json" . }}`, so edits to the template propagate to every platform. `.chezmoiignore` hides the inactive tree per OS (the Windows path on macOS/Linux, and vice versa) and also excludes Zed's local `prompts/` (LMDB) and `themes/` directories, which are machine state, not configuration.

The content is opinionated: Catppuccin (Latte/Mocha, system-following), FiraCode Nerd Font with ligatures, format-on-save, inline git blame, inlay hints, `opencode` agent server, and Copilot Chat as the assistant default. No vim mode.

## iTerm2 color scheme

The Catppuccin Mocha iTerm2 preset lives at [`assets/catppuccin-mocha.itermcolors`](assets/catppuccin-mocha.itermcolors). To import:

1. iTerm2 > Settings (or Preferences) > Profiles > Colors
2. Click the "Color Presets..." dropdown in the bottom right
3. Choose "Import..." and select the file
4. Reopen the dropdown and select "catppuccin-mocha"

## Manual theme steps

A few tools can't be themed via dotfiles and need manual one-time setup:

### Slack

Open Slack > Preferences > Themes > Import theme > paste:

```
#1E1E2E,#181825,#CBA6F7,#1E1E2E,#11111B,#CDD6F4,#CBA6F7,#EBA0AC,#1E1E2E,#CDD6F4
```

Values are Catppuccin Mocha. Source: https://github.com/catppuccin/slack

### OpenCode

Catppuccin is built into OpenCode. In the TUI, run `/theme` and pick `catppuccin` (Mocha flavor). No file changes needed.

## Troubleshooting

Run `chezmoi doctor` first. It verifies chezmoi version, git, required binaries (op, brew, scoop), template dependencies, and destination permissions. Most issues surface there.

### 1Password not signed in

```
template: dot_zshrc.tmpl:150: error calling onepasswordRead: ...
```

Sign in and retry:

```sh
op signin
chezmoi apply
```

### Homebrew not found on Apple Silicon

Apple Silicon installs Homebrew under `/opt/homebrew`, Intel under `/usr/local`. Both `.zprofile` and `.zshrc` include the shared template `brew-shellenv.sh` which detects the right prefix and runs `brew shellenv`. If `brew` is still not on PATH after `chezmoi apply`, ensure you opened a new shell (or `exec zsh`) so the profile is re-sourced.

### Windows: scoop buckets missing

Some packages live in the `extras` bucket. The scoop install script adds `main` and `extras`, but if you installed scoop manually before running apply, add them yourself:

```powershell
scoop bucket add main
scoop bucket add extras
```

Then re-run `chezmoi apply`.

## License

[MIT](LICENSE)
