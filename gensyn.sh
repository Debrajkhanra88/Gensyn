#!/bin/bash

# Auto-Install Script for Dependencies (Terminal Friendly)

PROJECT_DIR="$HOME/rl-swarm"
GIT_REPO="https://github.com/gensyn-ai/rl-swarm"

print_section() {
    echo -e "\n###############################################"
    echo "### $1"
    echo -e "###############################################\n"
}

set -e  # Exit on error

print_section "1. Updating System Packages"
sudo apt-get update && sudo apt-get upgrade -y

print_section "2. Installing General Utilities and Tools"
sudo apt install -y \
    screen curl iptables build-essential git wget lz4 jq \
    make gcc nano automake autoconf tmux htop nvme-cli \
    libgbm1 pkg-config libssl-dev libleveldb-dev tar clang \
    bsdmainutils ncdu unzip nvtop netcat-traditional

print_section "3. Installing Python"
sudo apt-get install -y python3 python3-pip python3-venv python3-dev

print_section "4. Installing Node.js"
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    echo "Node.js is already installed: $(node -v)"
fi

print_section "5. Installing Yarn"
if ! command -v yarn &> /dev/null; then
    curl -o- -L https://yarnpkg.com/install.sh | bash
    export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
    echo 'export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"' >> ~/.bashrc
else
    echo "Yarn is already installed: $(yarn -v)"
fi

print_section "6. Setting Up Project Repository"
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Cloning repository..."
    git clone "$GIT_REPO" "$PROJECT_DIR"
else
    echo "Project directory already exists, skipping clone"
fi

print_section "7. Cleaning Up"
sudo apt-get autoremove -y

print_section "8. Verifying Installations"
echo "Node.js location: $(which node)"
echo "Node.js version: $(node -v)"
echo "Yarn location: $(which yarn)"
echo "Yarn version: $(yarn -v)"
echo "Python version: $(python3 --version)"
echo "Git version: $(git --version)"

print_section "✅ Installation Complete!"
echo "You're all set!"
