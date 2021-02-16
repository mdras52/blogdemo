#! /bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install nginx -y

# using AWS RDS mysql
# sudo apt-get install mysql-server -y

# node
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash
sudo apt-get install -y nodejs

# ghost
sudo npm install ghost-cli@latest -g

# firewall for nginx
sudo ufw allow 'Nginx Full'

sudo mkdir -p /var/www/${site_name}
sudo chown ubuntu:ubuntu /var/www/${site_name}
sudo chmod 775 /var/www/${site_name}
cd /var/www/${site_name}

# see https://ghost.org/docs/ghost-cli/ for command line options
# caveat here: password needs quoting/special character handling if it contains
cat >/home/ubuntu/setup_ghost.sh <<EOL
#! /bin/bash
ghost install \
 --dir /var/www/${site_name} \
 --url=${url} \
 --db=mysql \
 --dbhost=${db_endpoint} \
 --dbuser=${db_user} \
 --dbpass=${db_pass} \
 --dbname=${site_name}_prod \
 --no-prompt \
 --no-setup-ssl
EOL

sudo chmod +x /home/ubuntu/setup_ghost.sh
su ubuntu -c '/home/ubuntu/setup_ghost.sh'

# remove default nginx site
sudo rm /etc/nginx/sites-enabled/default

sudo service nginx restart

# logs for output of this will be at /var/log/cloud-init.log on the instance
# currently, this script will be at /var/lib/cloud/instance/scripts on the instance
