#!/bin/bash
# 币哨监控系统 - 快速部署脚本

set -e

echo "🚨 币哨监控系统 - 服务器部署脚本"
echo "=================================="

# 检查 Python 版本
echo "📋 检查 Python 版本..."
python3_version=$(python3 --version 2>&1 | awk '{print $2}')
required_version="3.10"

if ! python3 -c "import sys; exit(0 if sys.version_info >= (3, 10) else 1)"; then
    echo "❌ Python 3.10+ 未找到，当前版本: $python3_version"
    echo "请先安装 Python 3.10 或更高版本"
    exit 1
fi

echo "✅ Python 版本: $python3_version"

# 创建虚拟环境
if [ ! -d "venv" ]; then
    echo "📦 创建虚拟环境..."
    python3 -m venv venv
else
    echo "✅ 虚拟环境已存在"
fi

# 激活虚拟环境
echo "🔄 激活虚拟环境..."
source venv/bin/activate

# 升级 pip
echo "⬆️ 升级 pip..."
pip install --upgrade pip --quiet

# 安装依赖
echo "📥 安装依赖包..."
pip install -r requirements.txt --quiet

# 创建必要目录
echo "📁 创建必要目录..."
mkdir -p logs data
chmod 755 logs data

# 检查 .env 文件
if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        echo "📝 创建 .env 文件..."
        cp .env.example .env
        echo "⚠️  请编辑 .env 文件并填入 TELEGRAM_BOT_TOKEN"
        echo "   运行: nano .env"
    else
        echo "⚠️  .env 文件不存在，请手动创建并配置"
    fi
else
    echo "✅ .env 文件已存在"
fi

# 检查环境变量
if grep -q "your_bot_token_here" .env 2>/dev/null; then
    echo "⚠️  警告: .env 文件中包含占位符，请配置实际的 TELEGRAM_BOT_TOKEN"
fi

echo ""
echo "✅ 部署准备完成！"
echo ""
echo "📋 下一步："
echo "1. 编辑 .env 文件: nano .env"
echo "2. 测试运行: source venv/bin/activate && cd src && python main.py"
echo "3. 使用 PM2 启动: pm2 start ecosystem.config.js"
