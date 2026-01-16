#!/bin/bash
# 币哨监控系统 - Docker 一键部署脚本

set -e

echo "🚨 币哨监控系统 - Docker 部署脚本"
echo "=================================="

# 检查 Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安装"
    echo "安装命令: curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh"
    exit 1
fi

if ! command -v docker compose &> /dev/null && ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose 未安装"
    exit 1
fi

echo "✅ Docker 已安装: $(docker --version)"
echo "✅ Docker Compose 已安装"

# 检查 .env 文件
if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        echo "📝 创建 .env 文件..."
        cp .env.example .env
        echo "⚠️  请编辑 .env 文件并填入 TELEGRAM_BOT_TOKEN"
        echo "   运行: nano .env"
        
        read -p "是否现在编辑 .env 文件? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            nano .env
        fi
    else
        echo "❌ .env 文件不存在，请手动创建"
        exit 1
    fi
fi

# 检查环境变量
if grep -q "your_bot_token_here" .env 2>/dev/null; then
    echo "⚠️  警告: .env 文件中包含占位符，请配置实际的 TELEGRAM_BOT_TOKEN"
    read -p "是否继续? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# 创建目录
echo "📁 创建必要目录..."
mkdir -p data logs
chmod 755 data logs

# 构建镜像
echo "📦 构建 Docker 镜像..."
docker compose build

# 停止旧容器（如果存在）
if docker ps -a | grep -q coinwhistle-monitor; then
    echo "🛑 停止旧容器..."
    docker compose down
fi

# 启动容器
echo "🚀 启动容器..."
docker compose up -d

# 等待几秒让容器启动
sleep 3

# 查看状态
echo ""
echo "📊 容器状态："
docker compose ps

echo ""
echo "✅ 部署完成！"
echo ""
echo "📋 常用命令："
echo "  查看日志: docker compose logs -f"
echo "  查看状态: docker compose ps"
echo "  重启容器: docker compose restart"
echo "  停止容器: docker compose stop"
echo "  删除容器: docker compose down"
echo ""
echo "📖 详细文档请查看: DOCKER_DEPLOY.md"
