#! /usr/bin/bash
# 这里有 alias 和类似于 alias 的函数

## Chores
alias version="uname -a; echo; cat /etc/os-release"
alias pause="read -s -n 1 -p $'\033[s\033[2m请按任意键继续…\033[0m'; echo -ne '\033[u\033[2K'"
alias dotfiles='git --git-dir="$HOME/MyCode/MyGit/dotfiles.git" --work-tree="$HOME"'
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias pacman-autoremove='sudo pacman -Qtdq | sudo pacman -Rns -' # Q=>d:deps; t:unrequired;; R=>n:nosave(remove configs);s:recursively(remove unused deps)

## GitHub Hosts
function update-github-hosts() {
    set -u 到不存在的变量就会报错
    # 定义颜色输出
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    NC='\033[0m' # No Color
    DIM='\033[2m'
    DIVIDER="${DIM}==========================================${NC}"
    
    TEMP_FILE="/tmp/github_hosts_new_$$" # $$ 随机数
    TEMP_OLD="/tmp/github_hosts_old_$$"
    HOSTS_FILE="/etc/hosts"
    HOSTS_LINK="\033]8;;file://${HOSTS_FILE}\007${HOSTS_FILE}\033]8;;\007"
    
    DIFF_OP='--no-index --color --color-moved --word-diff=color'
    
    # 步骤1: 下载最新的 hosts 文件
    echo -e "${YELLOW}[步骤 1/3]${NC} 正在从 GitHub 下载最新的 hosts 映射..."
    if curl -o "$TEMP_FILE" "https://raw.hellogithub.com/hosts"; then
        echo -e "${GREEN}✓ 下载成功${NC} (文件大小: $(wc -c < "$TEMP_FILE") 字节)"
    else
        echo -e "${RED}✗ 下载失败，请检查网络连接${NC}"
        rm -f "$TEMP_FILE" "$TEMP_OLD"
        set +u
        return 1
    fi
    pause
    
    # 步骤2: 删除旧规则
    echo -e "${YELLOW}[步骤 2/3]${NC} 正在清除旧的 GitHub hosts 规则..."
    cat $HOSTS_FILE > $TEMP_OLD
    if sudo sed -i "/# GitHub520 Host Start/,/# Github520 Host End/d" "$HOSTS_FILE" 2>/dev/null; then
        echo -e "${GREEN}✓ 旧规则已清除，更改如下${NC}"
        pause
        git diff $TEMP_OLD $HOSTS_FILE $DIFF_OP
    else
        echo -e "${YELLOW}! 未找到旧规则（首次运行或已清理），继续执行...${NC}"
        # 不返回错误，继续执行
    fi
    
    # 验证删除是否真的执行了（检查是否还有标记）
    if grep -q "# GitHub520 Host Start" "$HOSTS_FILE" 2>/dev/null; then
        echo -e "${YELLOW}! 警告：旧规则可能未完全清除，将覆盖追加${NC}"
    fi
    
    # 步骤3: 追加新规则
    echo -e "${YELLOW}[步骤 3/3]${NC} 正在追加新的 hosts 规则..."
    if sudo tee -a "$HOSTS_FILE" < "$TEMP_FILE" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ 新规则已成功追加"
        echo -e "${DIM}${HOSTS_LINK} 现共有 $(grep -c "^[0-9]" "$HOSTS_FILE" | tail -1) 条 IP 映射记录\n更改如下${NC}"
        pause
        git diff $TEMP_OLD $HOSTS_FILE $DIFF_OP
    else
        echo -e "${RED}✗ 追加失败，请检查权限${NC}"
        rm -f "$TEMP_FILE" "$TEMP_OLD"
        set +u
        return 1
    fi
    
    echo -e "${YELLOW}[CLEAN UP]${NC} 清理临时文件..."
    rm -f "$TEMP_FILE" "$TEMP_OLD"
    # echo -e "${YELLOW}[CLEAN UP]${NC} 刷新缓存..."
    # resolvectl flush-caches
    
    # 验证最终结果
    echo -e $DIVIDER
    if tail -5 "$HOSTS_FILE" | grep -q "# GitHub520 Host End"; then
        echo -e "${GREEN}✓ 更新完成！${NC}"
    else
        echo -e "${RED}✗ 更新可能失败，请检查 ${HOSTS_FILE} 文件${NC}"
        set +u
        return 1
    fi
    
    set +u
    return 0
}

