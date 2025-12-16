#!/bin/bash

set -e

echo "Starting Ubuntu setup..."

# Update system
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install basic dependencies
echo "Installing basic dependencies..."
sudo apt install -y curl wget git zsh build-essential software-properties-common apt-transport-https ca-certificates gnupg lsb-release unzip

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh already installed, skipping..."
fi

# Install zsh-autosuggestions
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
    echo "zsh-autosuggestions already installed, skipping..."
fi


# Install Docker Desktop
if ! command -v docker &> /dev/null; then
    echo "Installing Docker Desktop..."
    wget https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb
    sudo apt install -y ./docker-desktop-amd64.deb
    rm docker-desktop-amd64.deb
    sudo usermod -aG docker $USER
else
    echo "Docker Desktop already installed, skipping..."
fi

# Install VS Code
if ! command -v code &> /dev/null; then
    echo "Installing VS Code..."
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
    sudo apt update
    sudo apt install -y code
    rm packages.microsoft.gpg
else
    echo "VS Code already installed, skipping..."
fi

# Install C/C++ tools
echo "Installing C/C++ tools..."
sudo apt install -y gcc g++ gdb make cmake

# Install Python and pip
echo "Installing Python and pip..."
sudo apt install -y python3 python3-pip python3-venv

# Install pyenv
if [ ! -d "$HOME/.pyenv" ]; then
    echo "Installing pyenv..."
    curl https://pyenv.run | bash
else
    echo "pyenv already installed, skipping..."
fi

# Install uv
if ! command -v uv &> /dev/null; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    echo "uv already installed, skipping..."
fi

# Install Node.js via NodeSource
if ! command -v node &> /dev/null; then
    echo "Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
else
    echo "Node.js already installed, skipping..."
fi


# Install Vim
if ! command -v vim &> /dev/null; then
    echo "Installing Vim..."
    sudo apt install -y vim
else
    echo "Vim already installed, skipping..."
fi

# Install Neovim
if ! command -v nvim &> /dev/null; then
    echo "Installing Neovim..."
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt update
    sudo apt install -y neovim
else
    echo "Neovim already installed, skipping..."
fi



# Install AWS CLI
if ! command -v aws &> /dev/null; then
    echo "Installing AWS CLI..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf aws awscliv2.zip
else
    echo "AWS CLI already installed, skipping..."
fi

# Install Google Cloud SDK
if ! command -v gcloud &> /dev/null; then
    echo "Installing Google Cloud SDK..."
    sudo rm -f /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
    sudo apt update
    sudo apt install -y google-cloud-cli
else
    echo "Google Cloud SDK already installed, skipping..."
fi

# Install Terraform
if ! command -v terraform &> /dev/null; then
    echo "Installing Terraform..."
    sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt-get update && sudo apt-get install -y terraform
else
    echo "Terraform already installed, skipping..."
fi

# Copy configurations
echo "Copying configuration files..."
[ -f configs/zshrc ] && cp configs/zshrc ~/.zshrc

# Set zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Setting zsh as default shell..."
    chsh -s $(which zsh)
fi

# Enable Docker service
sudo systemctl enable docker

echo "Setup completed!"
echo "Restart the terminal or logout/login to apply all configurations."
echo "Run 'newgrp docker' to use Docker without sudo."
