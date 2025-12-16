# ez-ubuntu-setup

Automated Ubuntu development environment setup script.

## Overview

This script automates the installation and configuration of a complete development environment for Ubuntu. It installs essential tools, programming languages, cloud CLIs, and applies custom configurations.

## What Gets Installed

### Shell & Terminal
- Zsh
- Oh My Zsh
- zsh-autosuggestions plugin

### Development Tools
- Git
- VS Code
- Vim
- Neovim
- Docker Desktop

### Programming Languages & Package Managers
- Python 3 (pip, venv)
- pyenv
- uv (Python package manager)
- Node.js (LTS)

### C/C++ Development
- gcc
- g++
- gdb
- make
- cmake

### Cloud & Infrastructure
- AWS CLI v2
- Google Cloud SDK
- Terraform

### System Utilities
- curl
- wget
- build-essential
- unzip
- Various system libraries

## Prerequisites

- Fresh Ubuntu installation (tested on Ubuntu 20.04+)
- Sudo privileges
- Internet connection

## Installation

1. Clone this repository:
```bash
git clone https://github.com/chagasma/ez-ubuntu-setup.git
cd ez-ubuntu-setup
```

2. Make the setup script executable:
```bash
chmod +x setup.sh
```

3. Run the setup script:
```bash
./setup.sh
```

The script will:
- Update system packages
- Install all tools and dependencies
- Copy configuration files from `configs/` directory
- Set zsh as the default shell

## Post-Installation

After the script completes:

1. Restart your terminal or logout/login to apply all configurations
2. Run `newgrp docker` to use Docker without sudo (or restart your system)
3. Verify installations:
```bash
zsh --version
docker --version
code --version
python3 --version
node --version
nvim --version
aws --version
gcloud --version
terraform --version
uv --version
```

## Project Structure

```
ez-ubuntu-setup/
├── setup.sh           # Main installation script
├── configs/
│   └── zshrc         # Zsh configuration file
└── README.md         # This file
```

## Configuration Files

The script copies custom configuration files from the `configs/` directory:

- `configs/zshrc` - Custom zsh configuration with:
  - Bira theme
  - Useful aliases
  - pyenv and uv PATH configuration
  - Development directory shortcuts

## Customization

Before running the script, you can customize:

1. Edit `configs/zshrc` to modify shell configurations and aliases
2. Comment out sections in `setup.sh` to skip specific installations
3. Add your own configuration files to the `configs/` directory

## Notes

- The script checks if tools are already installed and skips reinstallation
- All installations are handled via official repositories and package managers
- Docker Desktop requires a system restart to work properly
- Some tools (pyenv, uv) require shell restart to be available in PATH

## Troubleshooting

If you encounter issues:

1. Ensure you have sudo privileges
2. Check your internet connection
3. Review the script output for specific error messages
4. Run `sudo apt update` before running the script
5. For Docker issues, try `sudo systemctl start docker`

## License

MIT
