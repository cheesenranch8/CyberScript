#!/bin/bash
#!/bin/bash

# Enable UFW
sudo ufw enable

# Update and upgrade packages
sudo apt update
sudo apt upgrade -y
sudo apt-get update
sudo apt-get upgrade -y

# Install curl
sudo apt install curl -y

# Prompt to delete all .mp3 files
#read -p "Do you want to delete all .mp3 files? (Y/N): " choice
#if [[ "$choice" == "Y" || "$choice" == "y" ]]; then
#    sudo find / -name '*.mp3' -type f -delete 2>/dev/null
#fi

# Update the database for file location
sudo updatedb

# Set up automatic updates
sudo bash -c 'cat << EOF > /etc/apt/apt.conf.d/20auto-upgrades
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
EOF'

# Set password maximum days to 30
sudo sed -i 's/^PASS_MAX_DAYS\s*99999/PASS_MAX_DAYS  30/' /etc/login.defs
sudo sed -i 's/^PASS_MIN_DAYS\s*[0-9]*/PASS_MIN_DAYS 1/' /etc/login.defs
sudo sed -i '/^password\s*requisite\s*pam_pwquality.so/ s/$/ minlen=10/' /etc/pam.d/common-password

# Stop and disable nginx
sudo systemctl stop nginx
sudo systemctl disable nginx

# Remove specific packages
sudo apt remove ophcrack -y
sudo apt remove wireshark -y

# Autoremove unnecessary packages
sudo apt autoremove -y

# Disallow root login via SSH
sudo sed -i 's/^#*\s*PermitRootLogin\s*yes/PermitRootLogin no/' /etc/ssh/sshd_config
