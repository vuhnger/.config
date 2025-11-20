# macOS Configuration Files

Personal configuration files for various development tools and utilities on macOS.

## Contents

This repository contains configuration files for:

- **Alacritty** - GPU-accelerated terminal emulator with custom themes
- **btop** - Modern resource monitor with custom themes
- **Fish** - Friendly interactive shell
- **GitHub CLI (gh)** - Command-line interface for GitHub
- **GitHub Copilot** - AI pair programmer configuration
- **htop** - Interactive process viewer
- **Neovim (nvim)** - Hyperextensible Vim-based text editor
- **Raycast** - macOS productivity launcher
- **thefuck** - Command correction tool
- **tmux** - Terminal multiplexer with custom keybindings and plugins
- **Zsh** - Z shell with Oh My Zsh, custom aliases, and Powerlevel10k theme

## Quick Start (Automated Setup)

For a fresh macOS installation, use the automated setup script:

```bash
# Clone this repository
cd ~
git clone <your-repo-url> .config

# Run the automated setup script
cd ~/.config
./init.sh
```

The `init.sh` script will:
- Install Homebrew (if not already installed)
- Install all required tools (Alacritty, Neovim, tmux, btop, etc.)
- Install Oh My Zsh and Powerlevel10k
- Install tmux plugin manager (TPM)
- Install NVM (Node Version Manager)
- Create backups of existing config files
- Create all necessary symlinks
- Set up fzf key bindings
- Set Zsh as your default shell

After running the script, just restart your terminal and you're good to go!

## Manual Installation

If you prefer to install things manually or already have some tools installed:

### Prerequisites

Ensure you have Homebrew and the following tools installed:

```bash
# Core tools
brew install alacritty zsh fzf bat neovim tmux gh btop htop thefuck

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
brew install powerlevel10k

# tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
```

### Create Symlinks Manually

```bash
# Zsh
ln -sf ~/.config/zsh/.zshrc ~/.zshrc

# tmux
ln -sf ~/.config/tmux/tmux.conf ~/.tmux.conf

# Reload shell
source ~/.zshrc
```

Most other tools (Alacritty, Neovim, btop, gh, etc.) automatically look for their configs in `~/.config/`, so no additional symlinks are needed.

## Configuration Highlights

### Zsh (.zshrc)
- Oh My Zsh framework
- Powerlevel10k theme
- Custom aliases for git, python, vim, and more
- fzf integration for fuzzy finding
- bat (cat replacement) integration
- Node Version Manager (nvm) support
- Conda environment support

### tmux (tmux.conf)
- Custom prefix key: `Ctrl+Space` (instead of `Ctrl+b`)
- Vim-style pane navigation (`h`, `j`, `k`, `l`)
- Mouse support enabled
- Window numbering starts at 1
- Catppuccin Mocha theme
- Plugins:
  - tmux-sensible
  - vim-tmux-navigator
  - catppuccin-tmux
  - tmux-yank

### Alacritty
- Custom color schemes and themes
- GPU-accelerated rendering
- Font and opacity configurations

## Post-Installation

1. **Reload your shell**:
   ```bash
   source ~/.zshrc
   ```

2. **Install tmux plugins**:
   Press `Ctrl+Space` + `I` (capital i) in tmux to install plugins

3. **Configure Powerlevel10k**:
   ```bash
   p10k configure
   ```

4. **Update Neovim plugins** (if using a plugin manager):
   ```bash
   nvim +PluginInstall +qall
   ```

## Updating Configurations

When you make changes to any config file:

1. Edit the file in `~/.config/<tool>/`
2. Commit and push changes:
   ```bash
   cd ~/.config
   git add .
   git commit -m "Update <tool> config"
   git push
   ```

## Security & Privacy

This repository does **not** contain:
- API keys or tokens
- Passwords or credentials
- SSH keys or certificates

However, it does contain:
- **Usernames**: GitHub and UiO usernames in `gh/hosts.yml`
- **Personal aliases**: Custom command shortcuts and directory paths in `.zshrc`
- **SSH connection strings**: University server connection info

### What's Excluded (via .gitignore)

The following directories are excluded from version control:
- `github-copilot/` - May contain authentication data
- `raycast/extensions/` - Large compiled extension files
- `*.log` files - Log files that may contain sensitive info
- `*.bak` files - Backup files

### Recommendations

1. Review `gh/hosts.yml` and `.zshrc` before pushing to a public repository
2. Consider removing or anonymizing personal paths and server addresses
3. Authentication tokens are stored separately by tools like `gh` (GitHub CLI) and won't be committed

## Notes

- The Alacritty directory contains multiple backup files (`.bak`) from previous configurations
- GitHub Copilot settings are stored but may require re-authentication
- Some paths may need adjustment based on your system setup
- The `.zshrc` includes references to:
  - `/opt/anaconda3` - Conda installation
  - `~/powerlevel10k` and `/opt/homebrew/share/powerlevel10k` - Powerlevel10k theme

## License

Personal configuration files. Use at your own discretion.
