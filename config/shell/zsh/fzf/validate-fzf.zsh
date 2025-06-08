# fzf widget validation and fallback setup

# Function to check if fzf widgets are available
function validate_fzf_widgets {
    local widgets_missing=0
    
    if [[ -z "${widgets[fzf-history-widget]}" ]]; then
        echo "⚠️  fzf-history-widget not available"
        widgets_missing=1
    fi
    
    if [[ -z "${widgets[fzf-file-widget]}" ]]; then
        echo "⚠️  fzf-file-widget not available"
        widgets_missing=1
    fi
    
    if [[ -z "${widgets[fzf-cd-widget]}" ]]; then
        echo "⚠️  fzf-cd-widget not available"
        widgets_missing=1
    fi
    
    if [ $widgets_missing -eq 0 ]; then
        echo "✅ All fzf widgets are available"
    else
        echo "💡 Run 'fix-fzf-widgets' to diagnose and fix"
    fi
}

# Function to fix fzf widget issues
function fix-fzf-widgets {
    echo "🔧 Diagnosing fzf widget issues..."
    
    # Check if fzf is installed
    if ! command -v fzf &> /dev/null; then
        echo "❌ fzf is not installed. Installing..."
        sudo apt install -y fzf
        return
    fi
    
    # Check if fzf.zsh exists
    if [ ! -f ~/.fzf.zsh ]; then
        echo "❌ ~/.fzf.zsh not found. Creating..."
        /usr/share/doc/fzf/examples/install --all
    fi
    
    # Source fzf configuration
    if [ -f ~/.fzf.zsh ]; then
        echo "🔄 Sourcing fzf configuration..."
        source ~/.fzf.zsh
    fi
    
    # Reload zsh configuration
    echo "🔄 Reloading Zsh configuration..."
    source ~/.zshrc
    
    # Validate again
    validate_fzf_widgets
}
