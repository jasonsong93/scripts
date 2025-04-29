#!/bin/zsh

# ---Log outputs to a file
exec > >(tee -i script.log) 2>&1

# ---Logging function
log() {
  local level="$1"
  local message="$2"
  echo "[$level] $message"
}

# ---Function to update the system
update_system() {
  log "INFO" "Updating the system..."
  if sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y; then
    log "SUCCESS" "System update and cleanup completed successfully."
  else
    log "ERROR" "System update encountered an issue."
    exit 1
  fi
}

# ---Function to configure Git aliases
configure_git_aliases() {
  log "INFO" "Configuring Git aliases..."
  git config --global alias.co checkout
  git config --global alias.br branch
  git config --global alias.ci commit
  git config --global alias.st status
  log "SUCCESS" "Git aliases configured: co -> checkout, br -> branch, ci -> commit, st -> status."
}

# ---Function to install Neovim
install_neovim() {
  log "INFO" "Installing prerequisites for Neovim..."
  if sudo apt-get install ninja-build gettext cmake curl build-essential -y; then
    git clone https://github.com/neovim/neovim
    cd neovim || exit
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    cd build || exit
    if cpack -G DEB && sudo dpkg -i nvim-linux-x86_64.deb; then
      log "SUCCESS" "Neovim installed successfully."
    else
      log "ERROR" "Neovim installation failed during packaging or deployment."
      exit 1
    fi
    cd ../.. || exit
    sudo rm -rf "neovim"
  else
    log "ERROR" "Unable to install prerequisites for Neovim."
    exit 1
  fi
}

# ---Function to install Zsh
install_zsh() {
  log "INFO" "Installing Zsh shell..."
  if sudo apt install zsh -y; then
    log "INFO" "Setting Zsh as the default shell..."
    chsh -s "$(which zsh)"
    if grep -qxF "alias vim='nvim'" ~/.zshrc || echo "alias vim='nvim'" >> ~/.zshrc; then
      log "SUCCESS" "Default shell updated to Zsh."
    else
      log "ERROR" "Failed to update default shell to Zsh."
    fi
  else
    log "ERROR" "Failed to install Zsh."
    exit 1
  fi
}

# ---Function to install utility packages
install_utilities() {
  log "INFO" "Installing utility packages..."
  sudo apt install zip -y && log "SUCCESS" "Zip installed successfully."
  sudo apt install ripgrep -y && log "SUCCESS" "Ripgrep installed successfully."
  sudo apt install fzf -y && log "SUCCESS" "Fzf installed successfully."
}

# ---Function to install NVM and Node.js
install_nvm() {
  log "INFO" "Installing NVM (Node Version Manager)..."
  if curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash; then
    log "INFO" "Sourcing ~/.zshrc to enable NVM command..."
    source ~/.zshrc
    log "INFO" "Confirming NVM installation..."
    if command -v nvm >/dev/null 2>&1; then
      log "SUCCESS" "NVM installed successfully."
      log "INFO" "Installing the latest Node.js..."
      if nvm install node; then
        log "SUCCESS" "Node.js installed successfully."
        log "INFO" "Setting default Node.js version..."
        nvm alias default node
        log "SUCCESS" "Default Node.js version set successfully."
      else
        log "ERROR" "Failed to install Node.js."
        exit 1
      fi
    else
      log "ERROR" "NVM command not found after installation."
      exit 1
    fi
  else
    log "ERROR" "Failed to install NVM."
    exit 1
  fi
}

# ---Main script execution
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
  log "ERROR" "This script is designed for Linux systems."
  exit 1
fi

# Updating system
update_system

# Configuring Git aliases
read "git_alias_option?Do you want to configure Git aliases? (y/n): "
if [[ "$git_alias_option" == "y" ]]; then
  configure_git_aliases
fi

# Installing Neovim
read "neovim_option?Do you want to install Neovim? (y/n): "
if [[ "$neovim_option" == "y" ]]; then
  install_neovim
fi

# Installing Zsh
read "zsh_option?Do you want to install Zsh? (y/n): "
if [[ "$zsh_option" == "y" ]]; then
  install_zsh
fi

# Installing utilities
read "utilities_option?Do you want to install utilities (Zip, Ripgrep, Fzf)? (y/n): "
if [[ "$utilities_option" == "y" ]]; then
  install_utilities
fi

# Installing NVM and Node.js
read "nvm_option?Do you want to install NVM and Node.js? (y/n): "
if [[ "$nvm_option" == "y" ]]; then
  install_nvm
fi

log "SUCCESS" "Script execution completed successfully."

