set number " 显示行号
set cursorline " 突出显示当前行
set mouse=a " 启用鼠标
set wrap " 换行显示
set whichwrap=b,s,<,>,[,] " 允许在按左右方向键/空格/退格时跨行移动光标（原本就有 b s）
" 显示 Tab，多个空格连一起
if $TERM =~ 'xterm' || $TERM =~ 'screen' || $TERM =~ 'tmux' || $TERM =~ '256color'
    set list " 用于 listchars
    set listchars=tab:≈=⇒,multispace:·,lead:·,trail:▪,eol:↩
    " DECSCUSR
    " 0 or 1 (blinking block), 2 (steady block), 3 (blinking underline), 4 (steady underline), 5 (blinking bar/I-beam), 6 (steady bar).
    let &t_SI = "\e[5 q" " 插入模式
    let &t_SR = "\e[1 q" " 替换模式
    let &t_EI = "\e[2 q" " 普通模式及其他
    function! s:SendCursorSeq(seq) abort
        let l:seq = substitute(a:seq, '\\e', '\\033', 'g')
        silent! call system('printf "' . l:seq . '" >/dev/tty')
    endfunction
    augroup CursorShapeByMode
        autocmd!
        " 启动时立即应用普通模式光标样式
        autocmd VimEnter * call s:SendCursorSeq(&t_EI)
        " 退出时恢复终端默认光标样式
        autocmd VimLeave * call s:SendCursorSeq("\e[0 q")
    augroup END
else
    set nolist
endif

highlight StatusLine ctermfg=white ctermbg=blue cterm=bold
highlight StatusLineNC ctermfg=black ctermbg=grey
function! s:UpdateModeHL() abort " 根据当前模式更新 ModeHL 高亮组颜色
    let l:mode = mode(1)
    if l:mode ==# 'n'
        highlight StatusLine ctermfg=white ctermbg=blue cterm=bold " 普通模式 - 蓝色
    elseif l:mode ==# 'i'
        highlight StatusLine ctermfg=black ctermbg=green cterm=bold " 插入模式 - 绿色
    elseif l:mode ==# 'v' || l:mode ==# 'V' || l:mode ==# "\<C-V>"
        highlight StatusLine ctermfg=white ctermbg=magenta cterm=bold " 可视模式 - 紫色
    elseif l:mode ==# 'R'
        highlight StatusLine ctermfg=white ctermbg=red cterm=bold " 替换模式 - 红色
    else
        highlight StatusLine ctermfg=black ctermbg=yellow cterm=bold " 其他模式 - 黄色
    endif
endfunction
augroup ModeHLUpdate
    autocmd!
    autocmd ModeChanged * call <SID>UpdateModeHL()
    autocmd VimEnter,WinEnter,BufEnter * call <SID>UpdateModeHL()
augroup END

set laststatus=2 " 总是显示状态行
set statusline=
set statusline+=%t\ %r%m%h%w
set statusline+=%= " 开始右对齐
"set statusline+=%Y " 文件类型，用下一行
set statusline+=%{empty(&filetype)?'UNKNOW':&filetype}
set statusline+=\ \|\ %l\,%v
set statusline+=;\ %L
set statusline+=;\ %p%%

set tabstop=4 " Tab 长度
set softtabstop=4 " 将空格认定为“softtab”，可以按 Backspace 删掉 4 空格；也是 Tab 转化为的空格数
set shiftwidth=4 " 自动缩进为 4 空格
"set expandtab " 将 Tab 转为空格
set smartindent " 遇到 C 一类的 `{`，自动新行缩进
set autoindent " 延续上面的缩进

set nobackup
set noswapfile " 交换文件用于系统崩溃恢复 .swp$
set noundofile " 撤销历史，^.un~
set autoread " 文件监视，若文件改变则提示

set noerrorbells " 不发出声音
set novisualbell

set hlsearch " 高亮搜索项

" 鼠标滚动只一行
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

filetype plugin indent on
syntax on

colorscheme habamax
