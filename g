#!/bin/bash

set -e

echo -e "\033[0;32m>>> 正在部署 RL Swarm 节点（macOS + Python 3.11）\033[0m"

# 检查 Homebrew
if ! command -v brew &> /dev/null; then
    echo -e "\033[0;31m未检测到 Homebrew，正在安装...\033[0m"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 安装 pyenv 和 git
brew install pyenv git

echo -e "\033[0;34m>>> 初始化 pyenv 环境\033[0m"
export PYENV_ROOT="$HOME/.pyenv"
eval "$($PYENV_ROOT/bin/pyenv init --path)"
eval "$($PYENV_ROOT/bin/pyenv init -)"

# 安装 Python 3.11.8（如果未安装）
if ! pyenv versions | grep -q "3.11.8"; then
    pyenv install 3.11.8
fi

pyenv global 3.11.8

# 清除旧项目和环境
rm -rf ~/rl-swarm
mkdir -p ~/rl-swarm
cd ~/rl-swarm

echo -e "\033[0;34m>>> 克隆 RL Swarm 项目\033[0m"
git clone https://github.com/gensyn-ai/rl-swarm.git .

# 创建虚拟环境
python -m venv venv
source venv/bin/activate

# 安装依赖
pip install --upgrade pip
pip install -r requirements.txt || true
pip install git+https://github.com/learning-at-home/hivemind.git || true

# 启动训练脚本
PYTHONPATH=. python hivemind_exp/gsm8k/train_single_gpu.py
