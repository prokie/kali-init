#!/usr/bin/env bash
set -e

echo "=== Starting Kali Initialization (Zsh Edition) ==="

# Update package lists & ensure Zsh is installed
sudo apt update -y && sudo apt install --only-upgrade nmap
sudo apt install -y curl git wget build-essential zsh pkg-config

# Create the Zsh plugin directory if it doesn't exist
ZSH_CUSTOM_DIR="$HOME/.zsh_plugins"
mkdir -p "$ZSH_CUSTOM_DIR"

# Clone the Autocomplete and Syntax Highlighting plugins
echo "Installing Zsh plugins..."
if [ ! -d "$ZSH_CUSTOM_DIR/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM_DIR/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM_DIR/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM_DIR/zsh-syntax-highlighting"
fi

# Install 'uv'
echo "Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh

# NOTE: There is no 'ty' tool hosted by Astral. Commented out to prevent script failure.
# Install 'ty'
# curl -LsSf https://astral.sh/ty/install.sh | sh

# Install Rust via rustup
echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install VS Code
echo "Installing Visual Studio Code..."
wget -qO /tmp/vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
sudo apt install -y /tmp/vscode.deb


# Set timezone to Stockholm
echo "Configuring System Timezone..."
sudo timedatectl set-timezone Europe/Stockholm


# Generate a clean .zshrc file for the session
echo "Configuring .zshrc..."
cat << 'EOF' > "$HOME/.zshrc"
# Core environment paths
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
[ -f "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env"

# Initialize standard Linux completion system
autoload -Uz compinit && compinit

# Load the custom plugins we cloned
source "$HOME/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Customize autocomplete behavior (case-insensitive, tab menu navigation)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# VS Code root bypass alias
alias code='code --user-data-dir=~/.config/vscode --no-sandbox'

echo "Welcome to your customized Zsh environment!"

setxkbmap se

HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt APPEND_HISTORY
setopt SHARE_HISTORY

EOF

echo "=== Environment Setup Complete! ==="
