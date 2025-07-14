#!/bin/bash
set -e  # 任何命令失败立即终止脚本

# 显式定义路径（避免环境变量未设置）
ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"

echo "🍺 安装 Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" -y

echo "🔧 安装工具..."
brew install git curl wget zsh

echo "🎨 安装字体..."
brew install --cask font-meslo-lg-nerd-font

echo "⚡ 安装 Oh My Zsh..."
export RUNZSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "💎 安装 Powerlevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}/themes/powerlevel10k"

echo "🔌 安装插件..."
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"

# 配置 .zshrc (略)

echo "🔄 修改默认 Shell..."
sudo chsh -s "$(which zsh)" "$USER"  # 需管理员权限

echo "✅ 完成！请："
echo "1. 重启终端"
echo "2. 运行 p10k configure 生成主题配置"
echo "3. 在终端设置中启用 MesloLGS NF 字体"
