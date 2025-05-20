#!/bin/bash
sudo apt update
sudo apt install -y redis
sudo systemctl enable redis-server.service
sudo systemctl start redis-server.service

