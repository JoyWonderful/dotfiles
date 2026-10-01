#! /usr/bin/bash
# 这里有 alias 和类似于 alias 的函数

## Chores
alias version="uname -a; echo; cat /etc/os-release"
alias pause="read -s -n 1 -p $'\033[s\033[2m请按任意键继续…\033[0m'; echo -ne '\033[u\033[2K'"
alias dotfiles='git --git-dir="$HOME/MyCode/MyGit/dotfiles.git" --work-tree="$HOME"'
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias pacman-autoremove='sudo pacman -Qtdq | sudo pacman -Rns -' # Q=>d:deps; t:unrequired;; R=>n:nosave(remove configs);s:recursively(remove unused deps)

