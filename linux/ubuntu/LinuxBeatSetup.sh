# Note: Only for Debian-based installs. Ubuntu seems to be primary so this seemed to be the right choice.
# See https://www.elastic.co/guide/en/beats/auditbeat/current/auditbeat-installation-configuration.html for other options
# Install Auditbeat via apt
# Note: Will need to be updated if major version is updated beyond 7
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update && sudo apt-get install auditbeat -y
sudo systemctl enable auditbeat
# install auditd
sudo apt install auditd -y
# make sure auditd is stopped (auditbeat starts it on launch)
sudo systemctl stop auditd
# enable relevant modules

echo "configure auditbeat"
echo "\tremove existing config files"
sudo rm /etc/auditbeat/*.yml
echo "\tdo machine-specific config"
original_filename="/tmp/default_linux_config.yml"
sed -i "s/name: /name: $(hostname)/g" $original_filename
echo "\tput config into folder"
sudo mv $original_filename /etc/auditbeat/auditbeat.yml

echo "setup auditbeat"
cd /usr/share/auditbeat
sudo bin/auditbeat -c /etc/auditbeat/auditbeat.yml -path.home /usr/share/auditbeat setup
sudo systemctl enable auditbeat
echo "start auditbeat"
sudo systemctl start auditbeat
