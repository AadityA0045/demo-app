#!/bin/bash
set -e

echo "=== BeforeInstall: Stopping httpd (if running) ==="
if systemctl is-active --quiet httpd; then
  systemctl stop httpd
  echo "httpd stopped."
else
  echo "httpd not running."
fi
