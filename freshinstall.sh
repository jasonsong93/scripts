#!/bin/zsh

# ---Log outputs to a file
exec > >(tee -i script.log) 2>&1

# ---Function to update the system
update_system() {
  echo ">>> Initiating system update <<<"
  if sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y; then
    echo "System update and cleanup completed successfully."
  else
    echo "Error: System update encountered an issue."
    exit 1
  fi
  sleep 1.5
}

# ---Function to configure Git aliases
configure_git_aliases() {
  echo ">>> Configuring Git aliases <<<"
  git config --global alias.co checkout
  git config --global alias.br branch
  git config --global alias.ci commit
  git config --global alias.st status
  echo "Git aliases have been configured as follows:"
  echo "  co -> checkout"
  echo "  br -> branch"
  echo "  ci -> commit"
  echo "  st -> status"
  sleep 1.5
}

# ---Function to install Neovim
install_neovim() {
  echo ">>> Installing prerequisites for Neovim <<<"
  if sudo apt-get install ninja-build gettext cmake curl build-essential -y; then
    git clone https://github.com/neovim/neovim
    cd neovim || exit
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    cd build || exit
    if cpack -G DEB && sudo dpkg -i nvim-linux-x86_64.deb; then
      echo "Neovim installation completed successfully."
    else
      echo "Error: Neovim installation failed during packaging or deployment."
      exit 1
    fi
    cd ../.. || exit
    sudo rm -rf "neovim"
  else
    echo "Error: Unable to install prerequisites for Neovim."
    exit 1
  fi
  sleep 1.5
}

# ---Function to install Zsh
install_zsh() {
  echo ">>> Installing Zsh shell <<<"
  if sudo apt install zsh -y; then
    echo "Setting Zsh as the default shell..."
    chsh -s "$(which zsh)"
    if grep -qxF "alias vim='nvim'" ~/.zshrc || echo "alias vim='nvim'" >> ~/.zshrc; then
      echo "Default shell updated to Zsh successfully."
    else
      echo "Error: Failed to update default shell to Zsh."
    fi
  else
    echo "Error: Failed to install Zsh."
    exit 1
  fi
}

# ---Function to install utility packages
install_utilities() {
  echo ">>> Installing Zip <<<"
  sudo apt install zip -y && echo "Zip installed successfully."

  echo ">>> Installing Ripgrep <<<"
  sudo apt install ripgrep -y && echo "Ripgrep installed successfully."

  echo ">>> Installing Fzf <<<"
  sudo apt install fzf -y && echo "Fzf installed successfully."
}

# ---Main script execution
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
  echo "Error: This script is designed for Linux systems."
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

echo "Script execution completed successfully."

