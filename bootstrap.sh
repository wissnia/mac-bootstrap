#!/bin/bash
# bootstrap.sh - For fresh Mac with private dotfiles

set -e

echo "🚀 macOS Setup - Private Repo Bootstrap"
echo ""

# 1. Install Xcode CLI Tools
if ! xcode-select -p &>/dev/null; then
  echo "📦 Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "⏳ Click 'Install' in the popup..."
  until xcode-select -p &>/dev/null; do sleep 5; done
  echo "✅ Xcode CLI Tools installed"
else
  echo "✅ Xcode CLI Tools already installed"
fi

# 2. Install Homebrew
if ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add to PATH for Apple Silicon
  if [[ $(uname -m) == 'arm64' ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  echo "✅ Homebrew installed"
else
  echo "✅ Homebrew already installed"
fi

# 3. Install git
echo "📦 Installing git..."
brew install git

read -p "Enter your GitHub username: " github_user

# 4. Setup SSH key for GitHub (if not exists)
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  echo "🔑 Generating SSH key..."
  ssh-keygen -t ed25519 -C "$github_user" -f "$HOME/.ssh/id_ed25519" -N ""

  # Start ssh-agent
  eval "$(ssh-agent -s)"
  ssh-add "$HOME/.ssh/id_ed25519"

  echo ""
  echo "📋 Your public SSH key (copy this to GitHub):"
  echo "   https://github.com/settings/ssh/new"
  echo ""
  cat "$HOME/.ssh/id_ed25519.pub"
  echo ""
  read -p "Press Enter after adding the key to GitHub..."

  # Test connection
  ssh -T git@github.com || true
else
  echo "✅ SSH key already exists"
fi

# 5. Clone private repo
SETUP_DIR="$HOME/personal/Projects/ansible-local"
if [ ! -d "$SETUP_DIR" ]; then
  echo "📥 Cloning ansible-local setup repository..."
  git clone git@github.com:"${github_user}"/ansible-local.git "$SETUP_DIR"
else
  echo "✅ Repository already cloned"
fi

# 6. Run the setup
cd "$SETUP_DIR"
echo "🎯 Running setup..."
make install

echo ""
echo "🎉 Setup complete!"
echo "Restart your terminal or run: source ~/.zshrc"
