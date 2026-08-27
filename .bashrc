# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# append to the history file, don't overwrite it
shopt -s histappend
# 不记录空格开头的命令，且不记录连续两条重复命令
# See bash(1) for more options
HISTCONTROL='ignoreboth'
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=200
HISTFILESIZE=200

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

# https://wiki.archlinux.org/title/Bash/Prompt_customization
if [ "$color_prompt" = yes ]; then
    # PS1='\[\033[1;32m\]\u@\h\[\033[0m\]:\[\033[1;34m\]\w\[\033[0m\]\$ '
    PS1='\[\033[1;92m\]\u@\h\[\033[0m\]:\[\033[1;94m\]\[\033]8;;file://${PWD}\007\]\w\[\033]8;;\007\]\[\033[0m\]\$ '
    # `\[` 和 `\]` 包裹着 VT 转义序列（不展位字符），使 bash 能正确计算自动换行
    # 超链接使用 `\033]8;;<_uri>\007<_text>\033]8;;\007` 格式
    # 不展位字符应该包含 _uri 在内，因为这也是不显示的
    # 
    # 拆解一下（去掉了 `\[` 和 `\]`）：
    # - `\033[1;32m\u@\h`                   以绿色粗体显示 `<username>@<hostname>`
    # - `\033[0m:`                          以正常颜色显示一个冒号
    # - `\033[1;34m`                        后文以蓝色粗体显示
    # - `\[\033]8;;file://${PWD}\007\]\w\[\033]8;;\007\]`
    #   显示当前工作目录，并用 `file:` 协议的超链接指向当前工作目录（href/uri 不能用 \w，不然无法解析 `~` 用户主目录）
    # - `\[\033[0m\]\$ `                    以正常颜色显示提示符（`$` 或 `#`）和空格
    # 
    # cheatsheet:
    # \u 表示用户(username)；
    # \h 表示主机(hostname)；
    # \w 表示当前工作目录(directory)；
    # \$ 如果您不是超级用户 (非root)，则插入一个 "$"；如果您是超级用户（root），则显示一个 "#"。
    # \[ 这个字符应该出现在不占位转义字符（如颜色转义字符）之前，它使bash能够正确计算自动换行；
    # \] 这个字符应该出现在不占位转义字符（如颜色转义字符）之后；
    # \e ASCII转义字符序列开始（也可以键入 \033）；
    # \a ASCII响铃字符（也可以键入 \007）；
    # \d "Wed Sep 06"格式的日期；
    # \H 主机的全称（如 "mybox.mydomain.com"）；
    # \j 在此shell中通过按 ^Z挂起的进程数；
    # \l 此shell的终端设备名 （如"ttyp4"）；
    # \n 换行符；
    # \r 回车符；
    # \s shell的名称（如 "bash"）；
    # \t 24小时制时间（如 "23:01:01"）；
    # \T 12小时制时间（如 "11:01:01"）；
    # \@ 带有 am/pm的 12小时制时间；
    # \v bash的版本（如 2.04）；
    # \V Bash版本（包括补丁级别） ?/td>;
    # \W 当前工作目录的“基名 (basename)”（如 "drobbins"）；
    # \! 当前命令在历史缓冲区中的位置；
    # \# 命令编号（只要您键入内容，它就会在每次提示时累加）；
    # \xxx 插 入一个用三位数 xxx（用零代替未使用的数字，如 "/007"）表示的 ASCII 字符；
    # \\ 反斜 杠。 
else
    PS1='\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    
    alias pacman='pacman --color=auto'
    alias pactree='pactree --color'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
# Yes, it's already enabled in /etc/bash.bashrc --jywon
#if ! shopt -oq posix; then
#  if [ -f /usr/share/bash-completion/bash_completion ]; then
#    . /usr/share/bash-completion/bash_completion
#  elif [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#  fi
#fi

###################
# My real profile #
###################
#可参考 https://wangdoc.com/bash/

# blesh    下载最新：
# https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz
BLESH_SRC='/usr/local/share/blesh/ble.sh'
if [ -f $BLESH_SRC ]; then
    source $BLESH_SRC
fi

export VIRTUAL_ENV_DISABLE_PROMPT=true # 禁用 venv 修改 prompt

# 退出后（哪怕是非登录 shell）执行
trap '. "$HOME/.bash_non-login_logout"' EXIT
