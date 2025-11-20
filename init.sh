#!/bin/bash

# macOS Configuration Setup Script
# This script installs all necessary tools and creates symlinks for configuration files

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_info() {
    echo -e "${BLUE}ℹ ${NC}$1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is designed for macOS only"
    exit 1
fi

print_info "Starting macOS configuration setup..."

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    print_warning "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    print_success "Homebrew installed"
else
    print_success "Homebrew already installed"
fi

# Update Homebrew
print_info "Updating Homebrew..."
brew update

# Install core tools
print_info "Installing core development tools..."

# Terminal and shell
tools=(
    "alacritty"
    "zsh"
    "fzf"
    "bat"
    "neovim"
    "tmux"
    "gh"
    "btop"
    "htop"
    "thefuck"
)

for tool in "${tools[@]}"; do
    if brew list "$tool" &>/dev/null; then
        print_success "$tool already installed"
    else
        print_info "Installing $tool..."
        brew install "$tool"
        print_success "$tool installed"
    fi
done

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "Oh My Zsh installed"
else
    print_success "Oh My Zsh already installed"
fi

# Install Powerlevel10k
if [ ! -d "$HOME/powerlevel10k" ]; then
    print_info "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    print_success "Powerlevel10k installed"
else
    print_success "Powerlevel10k already installed"
fi

# Install Powerlevel10k via Homebrew (alternative location)
if brew list powerlevel10k &>/dev/null; then
    print_success "Powerlevel10k (Homebrew) already installed"
else
    print_info "Installing Powerlevel10k via Homebrew..."
    brew install powerlevel10k
    print_success "Powerlevel10k (Homebrew) installed"
fi

# Install tmux plugin manager (TPM)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    print_info "Installing tmux plugin manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    print_success "TPM installed"
else
    print_success "TPM already installed"
fi

# Install NVM (Node Version Manager)
if [ ! -d "$HOME/.nvm" ]; then
    print_info "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    print_success "NVM installed"
else
    print_success "NVM already installed"
fi

# Create necessary directories
print_info "Creating necessary directories..."
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/nvim
mkdir -p ~/.cache

# Backup existing config files
print_info "Backing up existing configuration files..."
backup_dir="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup_dir"

files_to_backup=(
    "$HOME/.zshrc"
    "$HOME/.tmux.conf"
    "$HOME/.p10k.zsh"
)

for file in "${files_to_backup[@]}"; do
    if [ -f "$file" ] && [ ! -L "$file" ]; then
        cp "$file" "$backup_dir/"
        print_success "Backed up $(basename $file) to $backup_dir"
    fi
done

# Create symlinks
print_info "Creating symlinks..."

# Zsh
if [ -f "$HOME/.config/zsh/.zshrc" ]; then
    ln -sf "$HOME/.config/zsh/.zshrc" "$HOME/.zshrc"
    print_success "Linked .zshrc"
else
    print_warning ".config/zsh/.zshrc not found, skipping"
fi

# tmux
if [ -f "$HOME/.config/tmux/tmux.conf" ]; then
    ln -sf "$HOME/.config/tmux/tmux.conf" "$HOME/.tmux.conf"
    print_success "Linked tmux.conf"
else
    print_warning ".config/tmux/tmux.conf not found, skipping"
fi

# Install fzf key bindings and fuzzy completion
if command -v fzf &> /dev/null; then
    print_info "Setting up fzf..."
    if [ -f /opt/homebrew/opt/fzf/install ]; then
        /opt/homebrew/opt/fzf/install --key-bindings --completion --no-update-rc
    elif [ -f /usr/local/opt/fzf/install ]; then
        /usr/local/opt/fzf/install --key-bindings --completion --no-update-rc
    fi
    print_success "fzf configured"
fi

# Set Zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    print_info "Setting Zsh as default shell..."
    chsh -s $(which zsh)
    print_success "Zsh set as default shell"
else
    print_success "Zsh is already the default shell"
fi

print_success "Setup complete!"
echo ""
print_info "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Configure Powerlevel10k: p10k configure"
echo "  3. Open tmux and press Ctrl+Space + I to install tmux plugins"
echo "  4. If you use Neovim with plugins, run: nvim +PluginInstall +qall"
echo ""
print_info "Optional installations:"
echo "  - Anaconda/Miniconda for Python: https://docs.conda.io/en/latest/miniconda.html"
echo "  - Node.js via nvm: nvm install --lts"
echo ""
print_warning "A backup of your previous config files was saved to: $backup_dir"
echo ""
print_info "Enjoy your new setup!"
