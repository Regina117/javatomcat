#!/bin/bash
sudo apt update
sudo apt install -y redis-server redis-tools
sudo systemctl enable redis-server.service
sudo systemctl start redis-server.service

echo "bind 0.0.0.0" | sudo tee -a /etc/redis/redis.conf > /dev/null
echo "protected-mode no" | sudo tee -a /etc/redis/redis.conf > /dev/null

sudo systemctl restart redis-server.service

sudo ufw allow 6379
sudo systemctl status redis-server.service