#!/bin/bash
set -euo pipefail  # 严格模式：错误退出、未定义变量报错、管道错误检测

# 显式定义路径（避免环境变量未设置）
ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"

# 安装 Homebrew（若不存在）
if ! command -v brew &> /dev/null; then
    echo "🍺 安装 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" -y
    # 配置Homebrew环境变量（兼容M1/M2）
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# 安装基础工具
echo "🔧 安装工具..."
brew install git curl wget zsh zsh-completions

# 安装Nerd字体（支持Powerlevel10k图标）
echo "🎨 安装字体..."
brew install --cask font-meslo-lg-nerd-font

# 安装Oh My Zsh（非交互模式）
echo "⚡ 安装 Oh My Zsh..."
export RUNZSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# 安装Powerlevel10k主题
echo "💎 安装 Powerlevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}/themes/powerlevel10k"

# 安装Zsh插件（自动建议+语法高亮）
echo "🔌 安装插件..."
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"

# ================================
# 写入优化版.zshrc配置（核心变更）
# ================================
echo "⚙️ 生成 ~/.zshrc 配置文件..."
cat << 'EOF' > ~/.zshrc
# ==== 1. 基础环境 ====
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ==== 2. 历史记录强化 ====
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt EXTENDED_HISTORY      # 记录时间戳和命令持续时间
setopt INC_APPEND_HISTORY    # 实时追加历史而非退出时写入
setopt HIST_IGNORE_SPACE     # 忽略空格开头的命令（避免记录敏感操作）

# ==== 3. 路径优化 ====
path_dirs=(
  /opt/homebrew/bin
  /usr/local/bin
  $HOME/go/bin
  $HOME/.local/bin
)
export PATH="${(j.:.)path_dirs}:$PATH"

# ==== 4. 补全系统 ====
autoload -Uz compinit && compinit  # 启用Zsh补全引擎
autoload -Uz colors && colors      # 启用颜色支持

# ==== 5. Oh My Zsh配置 ====
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"  # 主题[5](@ref)
plugins=(
  git
  docker                  # Docker命令补全[8](@ref)
  terraform               # Terraform工作流优化
  aws                     # AWS CLI增强
  kubectl                 # Kubernetes快捷命令
  zsh-autosuggestions     # 基于历史的命令建议
  zsh-syntax-highlighting # 实时语法高亮（必须放在最后）[8](@ref)
)
source $ZSH/oh-my-zsh.sh

# ==== 6. DevOps工具链别名 ====
# Kubernetes[7](@ref)
alias k='kubectl'
alias kctx='kubectl config use-context'
alias kns='kubectl config set-context --current --namespace'
alias kpod='kubectl get pods -o wide --sort-by=".status.startTime"'

# Terraform[7](@ref)
alias tf='terraform'
alias tfi='terraform init -upgrade'
alias tfp='terraform plan'
alias tfa='terraform apply -auto-approve'

# Docker & Compose[8](@ref)
alias d='docker'
alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'

# 通用工具
alias ll='ls -lahG'
alias gs='git status'
alias gcm='git commit -m'

# ==== 7. 懒加载重型工具 ====
# nvm（按需加载）
export NVM_DIR="$HOME/.nvm"
nvm() {
  unfunction nvm
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  nvm "$@"
}

# ==== 8. Powerlevel10k主题配置 ====
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh  # 自动加载主题配置[5](@ref)

# ==== 9. 安全增强 ====
# 敏感配置隔离（避免误上传GitHub）
[ -f ~/.secure_env ] && source ~/.secure_env  # 存放AWS_PROFILE等
EOF
# ================================

# 修改默认Shell（兼容Linux/macOS）
echo "🔄 修改默认 Shell..."
if [[ "$SHELL" != "$(which zsh)" ]]; then
    sudo chsh -s "$(which zsh)" "$USER"   # 需管理员权限
fi

# 完成提示
echo "✅ 环境配置完成！请执行以下操作："
echo "1. 重启终端"
echo "2. 运行 'p10k configure' 生成主题样式"
echo "3. 在终端设置中启用 'MesloLGS NF' 字体"
echo "4. 敏感配置（如AWS凭证）请存入 ~/.secure_env"
