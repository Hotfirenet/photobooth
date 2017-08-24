#!/usr/bin/env bash
# Make a photobooth

# mkfifo fifo.mjpg
# gphoto2 --capture-movie --stdout> fifo.mjpg &
# omxplayer fifo.mjpg
# https://www.raspberrypi.org/forums/viewtopic.php?f=91&t=117102sudo rm /usr/share/gvfs/mounts/gphoto2.mountgit clone https://github.com/reuterbal/photobooth/home/pi/Desktop/Photobooth.desktop

sudo sh -c "echo 'display_rotate=2' >> /boot/config.txt"

apt-get -y remove --purge wolfram-engine
apt-get -y remove --purge libreoffice*
apt-get -y remove --purgeminecraft-pi
apt-get -y remove --purgesonic-pi

sudo apt-get clean
sudo apt-get autoremove

sudo apt-get update && sudo apt-get -y dist-upgrade
sudo apt-get -y install git apache2 php5 php5-gd gphoto2 libav-tools

sudo sh -c "echo 'www-data ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"

wget https://raw.githubusercontent.com/gonzalo/gphoto2-updater/master/gphoto2-updater.sh
chmod +x gphoto2-updater.sh
sudo ./gphoto2-updater.sh

sudo rm /usr/share/dbus-1/services/org.gtk.Private.GPhoto2VolumeMonitor.service
sudo rm /usr/share/gvfs/mounts/gphoto2.mount
sudo rm /usr/share/gvfs/remote-volume-monitors/gphoto2.monitor
sudo rm /usr/lib/gvfs/gvfs-gphoto2-volume-monitor

cd /var/www/html/

# sudo git clone https://github.com/andreknieriem/photobooth ./

sudo chown -R www-data: /var/www/html/

# sudo apt-get install chromium-browser

# sudo apt-get install cups


# sudo usermod -a -G lpadmin pi