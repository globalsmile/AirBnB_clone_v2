#!/usr/bin/env bash

# Install Nginx if not already installed
if ! dpkg -l nginx &> /dev/null; then
    sudo apt update
    sudo apt install -y nginx
fi

# Create directories if they don't exist
sudo mkdir -p /data/web_static/releases/test /data/web_static/shared

# Create fake HTML file
echo -e "<html>\n  <head>\n  </head>\n  <body>\n    Holberton School\n  </body>\n</html>" | sudo tee /data/web_static/releases/test/index.html > /dev/null

# Create symbolic link
sudo ln -sf /data/web_static/releases/test /data/web_static/current

# Give ownership to ubuntu user and group
sudo chown -R ubuntu:ubuntu /data/

# Update Nginx configuration
config="server {
    listen 80;
    server_name _;

    location /hbnb_static {
        alias /data/web_static/current/;
    }
}"
echo "$config" | sudo tee /etc/nginx/sites-available/hbnb_static > /dev/null

# Create symbolic link to enable the site
sudo ln -sf /etc/nginx/sites-available/hbnb_static /etc/nginx/sites-enabled/

# Restart Nginx
sudo systemctl restart nginx

# Exit successfully
exit 0

