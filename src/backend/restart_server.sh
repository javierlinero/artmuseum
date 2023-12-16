#!/bin/bash

# Stop nginx
sudo systemctl stop nginx.service

# Stop puamapp
sudo systemctl stop puamapp.service

# Reload daemon
sudo systemctl daemon-reload

# Start puamapp and enable it to start on boot
sudo systemctl start puamapp.service
sudo systemctl enable puamapp.service

# Start nginx
sudo systemctl start nginx.service