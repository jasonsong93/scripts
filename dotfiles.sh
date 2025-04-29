#!/bin/bash
set -e  # Stop on first error

# Get current date and time
now=$(date +"%Y-%m-%d %H:%M:%S")

# Delete old nvim backup
rm -rf ~/dotfiles/nvim

# Copy fresh nvim
cp -r ~/.config/nvim ~/dotfiles

# Go to dotfiles directory
cd ~/dotfiles

# Stage all changes
git add --all

# Commit with date/time message
git commit -m "Update nvim config: $now"

# Push to remote
git push

