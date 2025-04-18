#!/bin/bash
cp -r ~/.config/nvim ~/dotfiles

cd ~/dotfiles
git add --all
git commit
git push

