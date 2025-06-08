# Advanced Zsh functions for productivity
# Using modern function syntax: function name { ... }

# Project management
function pj {
    local project_dir="${PROJECTS_DIR:-$HOME/Projects}"
    local selected=$(find "$project_dir" -maxdepth 2 -type d | fzf)
    [ -n "$selected" ] && cd "$selected"
}

# Smart git worktree management
function gwt {
    case "$1" in
        "list"|"l")
            git worktree list
            ;;
        "add"|"a")
            [ -z "$2" ] && echo "Usage: gwt add <branch-name>" && return 1
            git worktree add "../$(basename $PWD)-$2" "$2"
            ;;
        "remove"|"r")
            local worktree=$(git worktree list | tail -n +2 | fzf | awk '{print $1}')
            [ -n "$worktree" ] && git worktree remove "$worktree"
            ;;
        *)
            echo "Usage: gwt {list|add|remove}"
            ;;
    esac
}

# Enhanced process management
function psgrep {
    ps aux | grep -v grep | grep -i "$1"
}

# Network utilities
function ports {
    case "$1" in
        "listen"|"l")
            netstat -tlnp | grep LISTEN
            ;;
        "all"|"a")
            netstat -tulanp
            ;;
        *)
            netstat -tulanp | grep "$1"
            ;;
    esac
}

# Docker helpers
function drun {
    local image="$1"
    shift
    docker run --rm -it "$image" "$@"
}

function dexec {
    local container=$(docker ps --format "{{.Names}}" | fzf)
    [ -n "$container" ] && docker exec -it "$container" "${1:-bash}"
}

function dlogs {
    local container=$(docker ps --format "{{.Names}}" | fzf)
    [ -n "$container" ] && docker logs -f "$container"
}

# Kubernetes helpers
function kexec {
    local pod=$(kubectl get pods --no-headers | fzf | awk '{print $1}')
    [ -n "$pod" ] && kubectl exec -it "$pod" -- "${1:-bash}"
}

function klogs {
    local pod=$(kubectl get pods --no-headers | fzf | awk '{print $1}')
    [ -n "$pod" ] && kubectl logs -f "$pod"
}

# File operations
function fcd {
    local dir=$(find . -type d 2>/dev/null | fzf)
    [ -n "$dir" ] && cd "$dir"
}

function fopen {
    local file=$(fzf)
    [ -n "$file" ] && $EDITOR "$file"
}

# System information
function weather {
    local city="${1:-Seoul}"
    curl "wttr.in/$city"
}

function cheat {
    curl "cheat.sh/$1"
}

# Development helpers
function serve {
    local port="${1:-8000}"
    python3 -m http.server "$port"
}

function jsonpp {
    if [ -t 0 ]; then
        # Input from argument
        echo "$1" | jq .
    else
        # Input from pipe
        jq .
    fi
}

# Git enhanced functions
function gfp {
    # Git fuzzy pick - interactive file selection for git operations
    local files=$(git status --porcelain | fzf -m | awk '{print $2}')
    [ -n "$files" ] && echo "$files"
}

function gbranch {
    # Interactive branch selection
    local branch=$(git branch -a | fzf | tr -d ' *')
    [ -n "$branch" ] && git checkout "$branch"
}

# Environment management
function envup {
    # Activate Python virtual environment
    if [ -f ".venv/bin/activate" ]; then
        source .venv/bin/activate
    elif [ -f "venv/bin/activate" ]; then
        source venv/bin/activate
    elif [ -f "env/bin/activate" ]; then
        source env/bin/activate
    else
        echo "No virtual environment found"
        return 1
    fi
}

# Quick notes
function note {
    local note_dir="${NOTES_DIR:-$HOME/Notes}"
    mkdir -p "$note_dir"
    
    if [ -z "$1" ]; then
        # List and select note
        local note=$(ls "$note_dir" | fzf)
        [ -n "$note" ] && $EDITOR "$note_dir/$note"
    else
        # Create or edit specific note
        $EDITOR "$note_dir/$1.md"
    fi
}

# System maintenance
function cleanup {
    echo "🧹 System cleanup started..."
    
    # APT cleanup
    sudo apt autoremove -y
    sudo apt autoclean
    
    # Docker cleanup
    if command -v docker &> /dev/null; then
        docker system prune -f
    fi
    
    # npm cache cleanup
    if command -v npm &> /dev/null; then
        npm cache clean --force
    fi
    
    # pip cache cleanup
    if command -v pip &> /dev/null; then
        pip cache purge
    fi
    
    # Clear logs
    sudo journalctl --vacuum-time=7d
    
    echo "✅ System cleanup completed!"
}

# Backup functions
function backup {
    local source="$1"
    local dest="${2:-./backup-$(date +%Y%m%d_%H%M%S)}"
    
    if [ -z "$source" ]; then
        echo "Usage: backup <source> [destination]"
        return 1
    fi
    
    rsync -av --progress "$source" "$dest"
}

# Advanced development functions
function mkcd {
    mkdir -p "$1" && cd "$1"
}

function extract {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Find and kill process
function fkill {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    if [ "x$pid" != "x" ]; then
        echo $pid | xargs kill -${1:-9}
    fi
}

# Git commit with conventional commits
function gcom {
    local type="$1"
    local message="$2"
    if [ -z "$type" ] || [ -z "$message" ]; then
        echo "Usage: gcom <type> <message>"
        echo "Types: feat, fix, docs, style, refactor, test, chore"
        return 1
    fi
    git commit -m "${type}: ${message}"
}

# Create Python virtual environment
function venv {
    if [ "$1" = "create" ]; then
        python3 -m venv .venv
        source .venv/bin/activate
        pip install --upgrade pip
    elif [ "$1" = "activate" ]; then
        source .venv/bin/activate
    elif [ "$1" = "deactivate" ]; then
        deactivate
    else
        echo "Usage: venv {create|activate|deactivate}"
    fi
}

# Docker cleanup
function docker-cleanup {
    docker system prune -af
    docker volume prune -f
}

# Show system information
function sysinfo {
    echo "=== System Information ==="
    echo "OS: $(lsb_release -d | cut -f2)"
    echo "Kernel: $(uname -r)"
    echo "Uptime: $(uptime -p)"
    echo "CPU: $(lscpu | grep 'Model name' | cut -d':' -f2 | xargs)"
    echo "Memory: $(free -h | grep '^Mem:' | awk '{print $3 "/" $2}')"
    echo "Disk: $(df -h / | tail -1 | awk '{print $3 "/" $2 " (" $5 " used)"}')"
}

# Python project initialization
function pyinit {
    local project_name="${1:-$(basename $PWD)}"
    
    # Create project structure
    mkdir -p {src,tests,docs}
    
    # Create virtual environment
    python3 -m venv .venv
    source .venv/bin/activate
    
    # Create basic files
    cat > requirements.txt << EOF
# Production dependencies

EOF

    cat > requirements-dev.txt << EOF
# Development dependencies
pytest>=7.0.0
black>=23.0.0
isort>=5.12.0
flake8>=6.0.0
mypy>=1.0.0
EOF

    cat > .gitignore << EOF
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# Virtual Environment
.venv/
venv/
ENV/
env/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Project specific
.env
.secrets
EOF

    cat > pyproject.toml << EOF
[build-system]
requires = ["setuptools>=45", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "$project_name"
version = "0.1.0"
description = ""
authors = [{name = "Your Name", email = "your.email@example.com"}]
license = {text = "MIT"}
readme = "README.md"
requires-python = ">=3.9"

[tool.black]
line-length = 88
target-version = ['py39']

[tool.isort]
profile = "black"
line_length = 88

[tool.mypy]
python_version = "3.9"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
EOF

    cat > README.md << EOF
# $project_name

## Installation

\`\`\`bash
pip install -r requirements.txt
\`\`\`

## Development

\`\`\`bash
pip install -r requirements-dev.txt
\`\`\`

## Usage

\`\`\`python
# Example usage
\`\`\`
EOF

    # Install development dependencies
    pip install -r requirements-dev.txt
    
    echo "✅ Python project '$project_name' initialized!"
    echo "📁 Structure created: src/, tests/, docs/"
    echo "🐍 Virtual environment activated"
    echo "📦 Development dependencies installed"
}

# Node.js project initialization
function nodeinit {
    local project_name="${1:-$(basename $PWD)}"
    
    # Initialize npm project
    npm init -y
    
    # Install common dev dependencies
    npm install -D \
        prettier \
        eslint \
        @typescript-eslint/parser \
        @typescript-eslint/eslint-plugin \
        typescript \
        @types/node
    
    # Create basic structure
    mkdir -p {src,tests,docs}
    
    # Create configuration files
    cat > .eslintrc.js << EOF
module.exports = {
  parser: '@typescript-eslint/parser',
  plugins: ['@typescript-eslint'],
  extends: [
    'eslint:recommended',
    '@typescript-eslint/recommended',
  ],
  env: {
    node: true,
    es2022: true,
  },
  parserOptions: {
    ecmaVersion: 2022,
    sourceType: 'module',
  },
};
EOF

    cat > .prettierrc << EOF
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2
}
EOF

    cat > tsconfig.json << EOF
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "lib": ["ES2022"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF

    echo "✅ Node.js project '$project_name' initialized!"
    echo "📁 Structure created: src/, tests/, docs/"
    echo "📦 TypeScript and linting tools installed"
}

# Load these functions
autoload -Uz ${functions[*]}