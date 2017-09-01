#!/usr/bin/env bash
# Make a photobooth

sudo apt-get clean
sudo apt-get autoremove

sudo apt-get update && sudo apt-get -y dist-upgrade
sudo apt-get -y install git apache2 php5 php5-gd


sudo sh -c "echo 'www-data ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"

wget https://raw.githubusercontent.com/gonzalo/gphoto2-updater/master/gphoto2-updater.sh
chmod +x gphoto2-updater.sh
sudo ./gphoto2-updater.sh

sudo rm /usr/share/dbus-1/services/org.gtk.Private.GPhoto2VolumeMonitor.service
sudo rm /usr/share/gvfs/mounts/gphoto2.mount
sudo rm /usr/share/gvfs/remote-volume-monitors/gphoto2.monitor
sudo rm /usr/lib/gvfs/gvfs-gphoto2-volume-monitor

sudo rm -r /var/www/html

cd /var/www/

sudo git clone https://github.com/Hotfirenet/photobooth.git html

sudo chown -R www-data: /var/www/html/

wget https://storage.googleapis.com/golang/go1.9.linux-armv6l.tar.gz
sudo tar -C /usr/local -xzf go1.9.linux-armv6l.tar.gz
export PATH=$PATH:/usr/local/go/bin

cd

git clone https://github.com/gonzaloserrano/go-selphy-cp.git

cd go-selphy-cp

sudo make

#Use ./selphy -printer_ip="192.168.1.115" picture.jpg

# sudo apt-get -y install cups

# sudo usermod -a -G lpadmin pi

# #sudo sh -c "sed -i 's/Listen localhost:631/Port 631/g' /etc/cups/cupsd.conf > /dev/null 2>&1"

# #sudo sh -c "echo '' > /etc/cups/cupsd.conf"

# sudo systemctl start cups

# sudo systemctl enable cups

# sudo apt-get install -y samba samba-common-bin

# sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.old

