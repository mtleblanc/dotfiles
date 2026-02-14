#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/dotfiles"
ZSH_PLUGINS="$HOME/.zsh"

# ── Detect OS ────────────────────────────────────────────
OS="$(uname -s)"
echo "Detected OS: $OS"

# ── Install packages ────────────────────────────────────
if [[ "$OS" == "Linux" ]]; then
    echo "Installing packages via apt..."
    sudo apt update
    sudo apt install -y zsh stow ripgrep fd-find fzf bat unzip

    # Neovim (PPA for 0.10+)
    if ! command -v nvim &>/dev/null || [[ "$(nvim --version | head -1 | grep -oP '\d+\.\d+')" < "0.10" ]]; then
        echo "Installing Neovim from PPA..."
        sudo add-apt-repository -y ppa:neovim-ppa/unstable
        sudo apt update
        sudo apt install -y neovim
    fi
elif [[ "$OS" == "Darwin" ]]; then
    echo "Installing packages via Homebrew..."
    if ! command -v brew &>/dev/null; then
        echo "Homebrew not found. Install it from https://brew.sh"
        exit 1
    fi
    brew install zsh stow neovim ripgrep fd fzf bat starship
fi

# ── Install Starship ────────────────────────────────────
if ! command -v starship &>/dev/null; then
    echo "Installing Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# ── SSH key ───────────────────────────────────────────────
if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
    echo "Generating SSH key..."
    ssh-keygen -t ed25519 -C "mtleblanc" -f "$HOME/.ssh/id_ed25519" -N ""
    echo ""
    echo "Public key (add to GitHub at https://github.com/settings/ssh/new):"
    cat "$HOME/.ssh/id_ed25519.pub"
    echo ""
fi

# ── Clone zsh plugins ───────────────────────────────────
mkdir -p "$ZSH_PLUGINS"

if [[ ! -d "$ZSH_PLUGINS/zsh-autosuggestions" ]]; then
    echo "Cloning zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS/zsh-autosuggestions"
fi

if [[ ! -d "$ZSH_PLUGINS/zsh-syntax-highlighting" ]]; then
    echo "Cloning zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_PLUGINS/zsh-syntax-highlighting"
fi

# ── Stow packages ───────────────────────────────────────
echo "Stowing dotfiles..."
cd "$DOTFILES"
for pkg in zsh tmux nvim git starship; do
    echo "  Stowing $pkg..."
    stow -R "$pkg"
done

# ── Change default shell ────────────────────────────────
ZSH_PATH="$(which zsh)"
if [[ "$SHELL" != "$ZSH_PATH" ]]; then
    echo "Changing default shell to zsh..."
    chsh -s "$ZSH_PATH"
fi

echo ""
echo "Done! Log out and back in (or run 'zsh') to start using your new config."
echo "Don't forget to add your SSH key to GitHub:"
echo "  cat ~/.ssh/id_ed25519.pub"
