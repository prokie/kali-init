#!/usr/bin/env bash
set -e

echo "=== Starting Linux Initialization ==="

# Update package lists & ensure required dependencies are installed
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
# Added ripgrep, fzf, and golang-go to the base system install
sudo apt install -y curl git wget build-essential zsh pkg-config libssl-dev ripgrep fzf golang-go

# Install Oh My Zsh 
echo "Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Set up Oh My Zsh custom plugins directory
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
mkdir -p "$ZSH_CUSTOM/plugins"

# Clone the Autocomplete and Syntax Highlighting plugins
echo "Installing Zsh plugins..."
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
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
echo "Configuring RustScan..."
if [ -f "rustscan.toml" ]; then
    ln -sf "$(pwd)/rustscan.toml" "$HOME/.rustscan.toml"
    echo "Symlinked rustscan.toml to ~/.rustscan.toml"
else
    echo "Warning: rustscan.toml not found in the current directory. Skipping."
fi

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
if [ -f ".zshrc" ]; then
    ln -sf "$(pwd)/.zshrc" "$HOME/.zshrc"
    echo "Symlinked .zshrc to ~/.zshrc"
else
    echo "Warning: .zshrc not found in the current directory. The default Oh My Zsh configuration will be retained."
fi

# Ensure Zsh is the default shell 
echo "Setting Zsh as default shell..."
sudo chsh -s $(which zsh) $(whoami)

echo "=== Environment Setup Complete! ==="