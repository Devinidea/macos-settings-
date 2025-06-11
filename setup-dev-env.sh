#!/bin/bash

echo "🍺 安装 Homebrew（如果未安装）..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "🔧 安装必需工具..."
brew install git curl wget zsh

echo "🎨 安装 Nerd Font (MesloLGS NF)..."
brew install --cask font-meslo-lg-nerd-font

echo "⚡ 安装 Oh My Zsh..."
export RUNZSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "💎 安装 Powerlevel10k 主题..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

echo "🔌 安装 Zsh 插件 (autosuggestions + syntax highlighting)..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "⚙️ 配置 .zshrc..."
cat <<EOF > ~/.zshrc
export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  docker
  terraform
  aws
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source \$ZSH/oh-my-zsh.sh

# AWS config (auto-complete)
export AWS_PROFILE=default

# Terraform config
export TF_PLUGIN_CACHE_DIR="\$HOME/.terraform.d/plugin-cache"
EOF

echo "✅ 配置 Powerlevel10k config..."
touch ~/.p10k.zsh # P10k 自动生成配置时会重写

echo "🔄 更改默认 shell 为 Zsh..."
chsh -s $(which zsh)

echo "🎉 全部完成！请重启 Terminal 或运行 'zsh' 激活配置。"
