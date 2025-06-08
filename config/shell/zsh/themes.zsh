# Theme management for terminal applications

theme() {
    local theme_name="$1"
    
    case "$theme_name" in
        "dark")
            export BAT_THEME="Catppuccin-mocha"
            export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=dark"
            echo "🌙 Switched to dark theme"
            ;;
        "light")
            export BAT_THEME="Catppuccin-latte"
            export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=light"
            echo "☀️ Switched to light theme"
            ;;
        "auto")
            # Auto-detect based on terminal background
            if [ "$COLORFGBG" = "15;0" ]; then
                theme dark
            else
                theme light
            fi
            ;;
        *)
            echo "Usage: theme {dark|light|auto}"
            echo "Current theme: ${BAT_THEME:-default}"
            ;;
    esac
}

# Auto-detect theme on startup
theme auto
