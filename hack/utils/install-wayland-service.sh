#!/bin/bash

# Install and enable symlink-wayland-socket.service

set -e

SERVICE_FILE="symlink-wayland-socket.service"
SERVICE_PATH="../../config/systemd/$SERVICE_FILE"
SYSTEMD_USER_DIR="$HOME/.config/systemd/user"

# Create systemd user directory if it doesn't exist
mkdir -p "$SYSTEMD_USER_DIR"

# Copy service file to systemd user directory
cp "$SERVICE_PATH" "$SYSTEMD_USER_DIR/"

# Reload systemd user daemon
systemctl --user daemon-reload

# Enable and start the service
systemctl --user enable "$SERVICE_FILE"
systemctl --user start "$SERVICE_FILE"

# Check service status
systemctl --user status "$SERVICE_FILE" --no-pager

echo "Wayland socket symlink service installed and started successfully!"
