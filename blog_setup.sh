# create directory for site content
sudo mkdir -p /var/www/yoursitename
sudo chown ghostuser:ghostuser /var/www/yoursitename
sudo chmod 775 /var/www/yoursitename

sudo su - ghostuser
cd /var/www/yoursitename
ghost
