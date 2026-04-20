#!/usr/bin/env zsh
# Terminal Welcome Screen - Catppuccin Mocha themed
# Shows useful shortcuts and system info

# Catppuccin Mocha colors
local reset="\033[0m"
local bold="\033[1m"
local dim="\033[2m"
local red="\033[38;5;210m"
local green="\033[38;5;158m"
local yellow="\033[38;5;223m"
local blue="\033[38;5;117m"
local magenta="\033[38;5;183m"
local cyan="\033[38;5;159m"
local peach="\033[38;5;216m"
local lavender="\033[38;5;183m"
local text="\033[38;5;255m"
local surface="\033[38;5;240m"

# Get system info
local hostname=$(hostname -s)
local user=$(whoami)
local shell_version="zsh ${ZSH_VERSION}"
local current_time=$(date "+%H:%M")
local current_date=$(date "+%a %b %d")

# Box drawing
local tl="╭" tr="╮" bl="╰" br="╯" h="─" v="│"

print_header() {
    echo ""
    echo "${magenta}${bold}  ╭─────────────────────────────────────────────────────────────╮${reset}"
    echo "${magenta}${bold}  │${reset}   ${cyan}${bold}Welcome back, ${user}${reset}${magenta}${bold}$(printf '%*s' $((43 - ${#user})) '')│${reset}"
    echo "${magenta}${bold}  │${reset}   ${dim}${current_date} ${current_time}  •  ${hostname}  •  ${shell_version}${reset}${magenta}${bold}$(printf '%*s' $((21 - ${#hostname})) '')│${reset}"
    echo "${magenta}${bold}  ╰─────────────────────────────────────────────────────────────╯${reset}"
    echo ""
}

print_section() {
    local title="$1"
    echo "${peach}${bold}  $title${reset}"
    echo "${surface}  ─────────────────────────────────────${reset}"
}

print_shortcut() {
    local key="$1"
    local desc="$2"
    printf "  ${green}%-18s${reset} ${text}%s${reset}\n" "$key" "$desc"
}

print_header

print_section "󰌌  Keybindings"
print_shortcut "Ctrl+R" "Search command history (atuin)"
print_shortcut "Ctrl+T" "Fuzzy find files"
print_shortcut "Ctrl+O" "Fuzzy cd into directory"
print_shortcut "Ctrl+P" "Toggle preview in fzf"
echo ""

print_section "  Navigation"
print_shortcut "z <dir>" "Smart jump (zoxide)"
print_shortcut "zi" "Interactive directory picker"
print_shortcut "br" "File tree navigator (broot)"
print_shortcut ".." "Go up one directory"
echo ""

print_section "  Git Shortcuts"
print_shortcut "lg" "Lazygit TUI"
print_shortcut "ga" "Interactive git add"
print_shortcut "glo" "Interactive git log"
print_shortcut "gd / gds" "Diff / Diff staged"
print_shortcut "gs" "Git status"
print_shortcut "gcb <name>" "Create & checkout branch"
echo ""

print_section "󰈔  File Commands"
print_shortcut "ls / la / lt" "List / all / tree"
print_shortcut "cat <file>" "View with syntax highlight"
print_shortcut "tree" "Show directory tree"
echo ""

print_section "  Dev Tools"
print_shortcut "mise use node@20" "Set Node version"
print_shortcut "direnv allow" "Enable .envrc in project"
print_shortcut "reload" "Reload shell config"
echo ""

# Optional: Show if in a git repo
if git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
    local branch=$(git branch --show-current 2>/dev/null)
    local repo=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
    echo "${surface}  ─────────────────────────────────────${reset}"
    echo "  ${blue}󰊢 ${repo}${reset} on ${magenta} ${branch}${reset}"
    echo ""
fi
