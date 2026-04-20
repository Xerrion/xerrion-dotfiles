# Ensure Homebrew is on PATH (chezmoi runs each script in its own subshell,
# so the preceding install-homebrew script's `eval brew shellenv` does not
# persist here).
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
