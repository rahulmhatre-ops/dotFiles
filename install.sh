#!/usr/bin/env zsh
# ── install.sh ───────────────────────────────────────────────────────────────
# Run this once to install all tools and symlink configs.
# Usage: chmod +x install.sh && ./install.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$HOME/.config"

echo "🐱 Starting terminal setup (Catppuccin Mocha edition)..."

# ── 1. Homebrew packages ──────────────────────────────────────────────────────
echo "\n📦 Installing Homebrew packages..."
brew install \
  zsh \
  zsh-autosuggestions \
  tmux \
  starship \
  carapace \
  fzf \
  zoxide \
  atuin \
  fd \
  bat \
  joshmedeski/sesh/sesh \
  neovim

# Ghostty — install via cask
brew install --cask ghostty

# Nerd Font for starship icons
brew install --cask font-jetbrains-mono-nerd-font

echo "✅ Packages installed."

# ── 2. TPM (Tmux Plugin Manager) ─────────────────────────────────────────────
echo "\n🔌 Installing TPM..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  echo "✅ TPM cloned."
else
  echo "✅ TPM already exists."
fi

# ── 3. Create config dirs ─────────────────────────────────────────────────────
echo "\n📁 Creating config directories..."
mkdir -p "$CONFIG_DIR/ghostty"
mkdir -p "$CONFIG_DIR/tmux"
mkdir -p "$CONFIG_DIR/atuin"
mkdir -p "$HOME/.local/share/zsh"
mkdir -p "$HOME/.cache/zsh"

# ── 4. Symlink configs ────────────────────────────────────────────────────────
echo "\n🔗 Symlinking configs..."

symlink() {
  local src="$1" dst="$2"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "$dst.bak"
    echo "  Backed up existing $dst → $dst.bak"
  fi
  ln -sf "$src" "$dst"
  echo "  Linked $src → $dst"
}

symlink "$DOTFILES_DIR/ghostty/config"      "$CONFIG_DIR/ghostty/config"
symlink "$DOTFILES_DIR/tmux/tmux.conf"      "$CONFIG_DIR/tmux/tmux.conf"
symlink "$DOTFILES_DIR/starship/starship.toml" "$CONFIG_DIR/starship.toml"
symlink "$DOTFILES_DIR/atuin/config.toml"   "$CONFIG_DIR/atuin/config.toml"
symlink "$DOTFILES_DIR/zsh/.zshrc"          "$HOME/.zshrc"

echo "✅ Configs linked."

# ── 5. Install tmux plugins ───────────────────────────────────────────────────
echo "\n🎨 Installing tmux plugins via TPM..."
~/.tmux/plugins/tpm/bin/install_plugins || echo "(Start tmux first if this fails, then press Prefix+I)"

# ── 6. Atuin login (optional) ────────────────────────────────────────────────
echo "\n🔐 Atuin sync (optional — skip if you don't use atuin sync):"
echo "   Run: atuin login && atuin sync"

# ── 7. Set zsh as default shell ───────────────────────────────────────────────
if [ "$SHELL" != "/bin/zsh" ]; then
  echo "\n🐚 Setting zsh as default shell..."
  chsh -s /bin/zsh
fi

echo "\n✅ Setup complete! Open Ghostty and start tmux."
echo "   • Inside tmux: press Prefix (Ctrl+Space) + I to install plugins"
echo "   • Launch sesh: Prefix + T"
echo "   • Ctrl+R for Atuin history, cd <dir> for zoxide"
