# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

###################
# My real profile #
###################
# https://wiki.archlinuxcn.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME=$HOME/.config # like /etc/
export XDG_CACHE_HOME=$HOME/.cache # like /var/cache/
export XDG_DATA_HOME=$HOME/.local/share # like /usr/share/
export XDG_STATE_HOME=$HOME/.local/state # like /var/lib/

# 如果在纯 tty（无图形化界面时）：
if [ $TERM = "linux" ]; then
    export LANG="en_US.UTF-8" # 使用英文，避免乱码
    # 终端字体在 /usr/share/kbd/consolefonts
    # 考虑 terminus-font 包
    # 在 /etc/vconsole.conf 指定好字体
fi
