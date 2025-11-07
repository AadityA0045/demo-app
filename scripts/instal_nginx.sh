#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

APP_DIR="/opt/demo-app"
REPO_URL="https://github.com/AadityA0045/demo-app.git"
LOGFILE="/var/log/demo-app-install.log"

exec > >(tee -a "$LOGFILE") 2>&1

echo "=== $(date) Starting demo-app installation ==="

# Detect OS
if [ -f /etc/os-release ]; then
  . /etc/os-release
  echo "Detected OS: $NAME $VERSION_ID"
else
  echo "Cannot determine OS."
  exit 1
fi

if [[ "$NAME" == "Amazon Linux" ]]; then
  echo "Updating packages..."
  sudo dnf clean all
  sudo dnf makecache
  sudo dnf update -y
  echo "Installing dependencies..."
  sudo dnf install -y nginx git
else
  echo "This script supports Amazon Linux only."
  exit 1
fi

# Enable NGINX
sudo systemctl enable --now nginx

# Clone or update repo
sudo mkdir -p "$APP_DIR"
if [ -d "$APP_DIR/.git" ]; then
  cd "$APP_DIR" && sudo git pull
else
  sudo git clone "$REPO_URL" "$APP_DIR"
fi

# Copy app files
sudo cp "$APP_DIR/index.html" /var/www/html/

# Permissions
sudo chown -R ec2-user:ec2-user "$APP_DIR" /var/www/html

echo "=== Installation complete! Visit http://<EC2-IP>/index.html ==="
