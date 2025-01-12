#!/bin/zsh

# Set global Git aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status

echo "Git aliases configured:"
echo "  co -> checkout"
echo "  br -> branch"
echo "  ci -> commit"
echo "  st -> status"
