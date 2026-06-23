#!/usr/bin/env bash
set -e

echo "=== Starting Kali Initialization (Zsh Edition) ==="

# Update package lists & ensure required dependencies are installed
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
# Added ripgrep, fzf, and golang-go to the base system install
sudo apt install -y curl git wget build-essential zsh pkg-config libssl-dev ripgrep fzf golang-go

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

# Install 'ty'
curl -LsSf https://astral.sh/ty/install.sh | sh

# Install Rust via rustup
echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Install modern security and CLI tools via Cargo
echo "Compiling Rust tools (rustscan, bat, feroxbuster, eza)..."
cargo install rustscan --locked
cargo install bat --locked
cargo install feroxbuster --locked
cargo install eza --locked

# Configure RustScan
echo "Creating RustScan configuration file..."
cat << 'EOF' > "$HOME/.rustscan.toml"
ulimit = 5000
command = ["-sV", "-sC"]
batch_size = 4500
EOF

# Install rapid web fuzzing tools via Go
echo "Installing Go-based pentesting tools (ffuf)..."
go install github.com/ffuf/ffuf/v2@latest

# Install VS Code
echo "Installing Visual Studio Code..."
wget -qO /tmp/vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
sudo apt install -y /tmp/vscode.deb

# Set timezone to Stockholm
echo "Configuring System Timezone..."
sudo timedatectl set-timezone Europe/Stockholm

# Configure global Git identity
echo "Configuring Git Global Settings..."
git config --global user.name "prokie"
git config --global user.email "36114799+prokie@users.noreply.github.com"

# Generate a clean .zshrc file
echo "Configuring .zshrc..."
cat << 'EOF' > "$HOME/.zshrc"
# Core environment paths
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
[ -f "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env"
# Ensure Go binaries are in the path execution line
[ -d "$HOME/go/bin" ] && export PATH="$PATH:$HOME/go/bin"

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt APPEND_HISTORY
setopt SHARE_HISTORY

# Fix keyboard layout on startup
setxkbmap se

# Initialize standard Linux completion system
autoload -Uz compinit && compinit

# Set up fzf shell integration
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh

# Useful Aliases
alias ls='eza --icons --git'
alias ll='eza -l --icons --git'
alias la='eza -la --icons --git'
alias grep='rg'

# Load the custom plugins we cloned
source "$HOME/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Customize autocomplete behavior (case-insensitive, tab menu navigation)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# Custom Command Prompt
PROMPT='%n%F{green}%#%f %F{cyan}%~%f '

# Bind Ctrl+Left and Ctrl+Right arrows to skip words
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

echo "Welcome to your customized Zsh environment!"
EOF

echo "=== Environment Setup Complete! ==="