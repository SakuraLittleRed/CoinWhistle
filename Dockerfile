FROM python:3.11-slim

WORKDIR /app

# 安装依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制代码
COPY src/ /app/src/

# 创建数据目录和日志目录
RUN mkdir -p /app/data /app/logs

# 设置 Python 路径（让 Python 能找到 src 目录下的模块）
ENV PYTHONPATH=/app/src

# 运行
WORKDIR /app/src
CMD ["python", "main.py"]
