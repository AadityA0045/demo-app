#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

LOGFILE="/var/log/demo-app-start.log"
exec > >(tee -a "$LOGFILE") 2>&1

echo "=== $(date) Starting demo-app ==="

if ! systemctl is-active --quiet nginx; then
  echo "Starting NGINX..."
  sudo systemctl start nginx
fi

echo "NGINX is running!"
echo "Access your app at: http://$(curl -s ifconfig.me)/index.html"
echo "=== $(date) demo-app started ==="
