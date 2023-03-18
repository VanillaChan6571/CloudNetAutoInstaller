COLOR_YELLOW='\033[1;33m'
COLOR_GREEN='\033[0;32m'
COLOR_RED='\033[0;31m'
COLOR_NC='\033[0m'

success() {
  echo ""
  echo -e "* ${COLOR_GREEN}SUCCESS${COLOR_NC}: $1" 1>&2
  echo ""
}

error() {
  echo ""
  echo -e "* ${COLOR_RED}ERROR${COLOR_NC}: $1" 1>&2
  echo ""
}

warning() {
  echo ""
  echo -e "* ${COLOR_YELLOW}WARNING${COLOR_NC}: $1" 1>&2
  echo ""
}

echo "============================================================================"
echo "CloudNet Install Script"
echo
echo "By Neko Network & NekoHosting"
echo "https://github.com/"
echo
echo "This will do the following:"
echo "1. Make Directories"
echo "2. Download v4 RC-8 Files of CloudNet"
echo "3. Unzip Files"
echo "4. Auto Systemd CloudNet"
echo
warning "Please make sure you run this as root!!!"
echo 
echo "============================================================================"

#Checks to continue#
#!/bin/bash

while true; do

read -p "Do you want to proceed? (y/N) " yn

case $yn in
	[yY] ) echo Continuing with the install;
		break;;
	[nN] ) echo Exiting...;
		exit;;
	* ) echo Invalid Response;;
esac

done

success "Making Directory -> /home/cloudnet/"
mkdir /home/cloudnet/

cd /home/cloudnet/

success "Attempting to Download Java 17"
warning "You will be prompted to install them! Press Y or N"
apt-get install openjdk-17-jdk openjdk-17-jre

success "Installing unzip"
apt-get install unzip

success "Installing wget"
apt-get install wget

success "Downloading Files..."
cd /home/cloudnet/

wget https://github.com/CloudNetService/CloudNet-v3/releases/download/4.0.0-RC8/CloudNet.zip

cd /home/cloudnet/

success "Unziping Files..."
unzip CloudNet.zip

success "Making Systemd Creation..."
curl -so /etc/systemd/system/cloudnet.service https://raw.githubusercontent.com/VanillaChan6571/CloudNetAutoInstaller/main/cloudnet.service
curl -so /home/cloudnet/vanillachan6571-start.sh https://raw.githubusercontent.com/VanillaChan6571/CloudNetAutoInstaller/main/vanillachan6571-start.sh

systemctl stop cloudnet.service # this is here if you decided to re-launch the script!

warning "Reloading Daemon!!"
systemctl daemon-reload # this is needed if some changes were made to cloudnet.service

success "Giving Permissions..."
chmod 644 /etc/systemd/system/cloudnet.service
chmod +x /home/cloudnet/vanillachan6571-start.sh

success "Enabling Systemd..."
systemctl start cloudnet.service
systemctl enable cloudnet.service


success "removing CloudNet.zip..."
cd /home/cloudnet/

rm CloudNet.zip

success "Installation Complete"
echo "You should now be able to run the following:"
echo
echo "sudo screen -r CloudNet"
echo
echo "Thank You for installing and using the auto installer!"