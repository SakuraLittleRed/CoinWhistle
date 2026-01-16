module.exports = {
  apps: [{
    name: 'coinwhistle',
    script: 'src/main.py',
    interpreter: './venv/bin/python',
    cwd: process.env.PWD || __dirname,
    autorestart: true,
    max_restarts: 10,
    restart_delay: 5000,
    watch: false,
    env: {
      PYTHONUNBUFFERED: '1',
      NODE_ENV: 'production',
      PYTHONPATH: process.env.PWD || __dirname
    },
    error_file: './logs/pm2-error.log',
    out_file: './logs/pm2-out.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
    merge_logs: true,
    time: true
  }]
}