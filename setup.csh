#!/usr/bin/env bash
# Exit immediately if a command exits with a non-zero status
set -e

echo "=== Starting Kali Live RAM Initialization ==="

# 1. Update package lists (essential for a fresh boot)
sudo apt update -y

# 2. Install curl and git if not present
sudo apt install -y curl git wget build-essential

# 3. Install 'uv' (Astral's ultra-fast Python package installer/manager)
echo "Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh
# Source the environment so 'uv' is immediately usable in this script
source $HOME/.local/bin/env

# 4. Install Rust via rustup (non-interactive mode)
echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# Source the cargo environment so rustc/cargo are available immediately
source $HOME/.cargo/env

# 5. Install VS Code
echo "Installing Visual Studio Code..."
# Download the official Debian package to the RAM drive
wget -qO /tmp/vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
sudo apt install -y /tmp/vscode.deb

echo "=== Environment Setup Complete! ==="
echo "Note: Please run 'source ~/.cargo/env' and 'source ~/.local/bin/env' in any open terminals."

# So vscode works
echo "alias code='code --user-data-dir=~/.config/vscode --no-sandbox'" >> ~/.bashrc
