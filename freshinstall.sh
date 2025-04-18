#!/bin/zsh
# ---Update Ubuntu
echo ">>>Updating Ubuntu<<<"
sudo apt update && sudo apt upgrade -y $$ sudo apt autoremove -y
echo ">>>Update complete<<<"
sleep 1.5

# ---Setting global Git aliases
echo ">>>Configuring global git aliases<<<"
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
echo ">>>Git aliases configured:<<<"
echo "  co -> checkout"
echo "  br -> branch"
echo "  ci -> commit"
echo "  st -> status"
sleep 1.5


# ---Installing neovim
# Build prerequisites
echo ">>>Installing neovim build prerequisites<<<"
sudo apt-get install ninja-build gettext cmake curl build-essential
git clone https://github.com/neovim/neovim
cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
cd build && cpack -G DEB && sudo dpkg -i nvim-linux-x86_64.deb
echo ">>>neovim succesfully installed<<<"
sleep 1.5

#---Installing zsh
echo ">>>Installing zsh<<<"
sudo apt install zsh -y
# Updating default shell
echo ">>>Updating default shell to zsh<<<"
chsh -s $(which zsh)
echo ">>>Update success<<<"
