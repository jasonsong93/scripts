#!/bin/bash
cp -r ~/.config/nvim ~/dotfiles
cp -r ~/.zshrc ~/dotfiles

cd ~/dotfiles
git add --all
git commit
git push
