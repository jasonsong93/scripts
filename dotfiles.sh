#!/bin/bash
cp -r ~/.config/nvim ~/dotfiles
cp -L /home/jasonsong/.zprezto/runcoms/zshrc ~/dotfiles

cd ~/dotfiles
git add --all
git commit
git push

