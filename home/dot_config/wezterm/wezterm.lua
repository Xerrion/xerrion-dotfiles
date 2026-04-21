local wezterm = require('wezterm')
local config = wezterm.config_builder()

-- OS detection for cross-platform modifier keys
local is_macos = wezterm.target_triple:find('darwin') ~= nil
local SUPER = is_macos and 'CMD' or 'CTRL'
local SUPER_SHIFT = is_macos and 'CMD|SHIFT' or 'CTRL|SHIFT'
local SUPER_ALT = is_macos and 'CMD|ALT' or 'CTRL|ALT'

-- Theme (Catppuccin Mocha is built-in to wezterm)
config.color_scheme = 'Catppuccin Mocha'

-- Fonts
config.font = wezterm.font_with_fallback({
  { family = 'FiraCode Nerd Font', weight = 'Regular' },
  { family = 'Apple Color Emoji' },
})
config.font_size = 14.0
config.line_height = 1.1
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }

-- Window
config.window_decorations = 'RESIZE'
config.window_background_opacity = 0.98
config.window_padding = { left = 12, right = 12, top = 8, bottom = 8 }
if is_macos then
  config.macos_window_background_blur = 20
  config.native_macos_fullscreen_mode = true
end

-- Tab bar
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 32

-- Scrollback and behavior
config.scrollback_lines = 10000
config.enable_scroll_bar = false
config.audible_bell = 'Disabled'
config.check_for_updates = false
config.adjust_window_size_when_changing_font_size = false
config.quit_when_all_windows_are_closed = true
config.warn_about_missing_glyphs = false

-- Cursor
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'

-- Keybindings (macOS feel)
local act = wezterm.action
config.keys = {
  -- Tabs
  { key = 't', mods = SUPER, action = act.SpawnTab('CurrentPaneDomain') },
  { key = 'w', mods = SUPER, action = act.CloseCurrentTab({ confirm = false }) },
  { key = 'LeftArrow', mods = SUPER_SHIFT, action = act.ActivateTabRelative(-1) },
  { key = 'RightArrow', mods = SUPER_SHIFT, action = act.ActivateTabRelative(1) },
  -- Cmd+1..9 to jump to tab N
  { key = '1', mods = SUPER, action = act.ActivateTab(0) },
  { key = '2', mods = SUPER, action = act.ActivateTab(1) },
  { key = '3', mods = SUPER, action = act.ActivateTab(2) },
  { key = '4', mods = SUPER, action = act.ActivateTab(3) },
  { key = '5', mods = SUPER, action = act.ActivateTab(4) },
  { key = '6', mods = SUPER, action = act.ActivateTab(5) },
  { key = '7', mods = SUPER, action = act.ActivateTab(6) },
  { key = '8', mods = SUPER, action = act.ActivateTab(7) },
  { key = '9', mods = SUPER, action = act.ActivateTabRelative(-1) }, -- 9 = last tab convention
  -- Panes (split like iTerm)
  { key = 'd', mods = SUPER, action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
  { key = 'd', mods = SUPER_SHIFT, action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },
  { key = 'LeftArrow', mods = SUPER_ALT, action = act.ActivatePaneDirection('Left') },
  { key = 'RightArrow', mods = SUPER_ALT, action = act.ActivatePaneDirection('Right') },
  { key = 'UpArrow', mods = SUPER_ALT, action = act.ActivatePaneDirection('Up') },
  { key = 'DownArrow', mods = SUPER_ALT, action = act.ActivatePaneDirection('Down') },
  { key = 'w', mods = SUPER_SHIFT, action = act.CloseCurrentPane({ confirm = false }) },
  -- Font size
  { key = '=', mods = SUPER, action = act.IncreaseFontSize },
  { key = '-', mods = SUPER, action = act.DecreaseFontSize },
  { key = '0', mods = SUPER, action = act.ResetFontSize },
  -- Clear scrollback
  { key = 'k', mods = SUPER, action = act.ClearScrollback('ScrollbackAndViewport') },
  -- Fullscreen
  { key = 'Enter', mods = SUPER, action = act.ToggleFullScreen },
  -- Command palette
  { key = 'p', mods = SUPER_SHIFT, action = act.ActivateCommandPalette },
  -- Copy/paste explicit (Cmd+C copies selection, Cmd+V pastes)
  { key = 'c', mods = SUPER, action = act.CopyTo('Clipboard') },
  { key = 'v', mods = SUPER, action = act.PasteFrom('Clipboard') },
}

-- Mouse: copy on select
config.mouse_bindings = {
  { event = { Up = { streak = 1, button = 'Left' } }, mods = 'NONE', action = act.CompleteSelection('ClipboardAndPrimarySelection') },
  -- Cmd+click opens URL
  { event = { Up = { streak = 1, button = 'Left' } }, mods = SUPER, action = act.OpenLinkAtMouseCursor },
}

-- Hyperlinks: auto-detect
config.hyperlink_rules = wezterm.default_hyperlink_rules()

return config
