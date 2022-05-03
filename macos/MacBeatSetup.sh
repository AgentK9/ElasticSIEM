#! /bin/zsh
# auditbeat
echo "download auditbeat"
curl -L -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-7.16.2-darwin-x86_64.tar.gz
mkdir -p /usr/local/etc/auditbeat/
tar xzvf auditbeat-7.16.2-darwin-x86_64.tar.gz
mv ./auditbeat-7.16.2-darwin-x86_64/* /usr/local/etc/auditbeat/
cd /usr/local/etc/auditbeat/
echo "configure auditbeat"
echo "remove existing config files"
rm /usr/local/etc/auditbeat/*.yml
echo "do machine-specific config"s
filename="/tmp/default_mac_config.yml"
sed -i '' "s/name\:/name\:\ $(hostname)/" $filename
echo "put config into folder"
mv $filename /usr/local/etc/auditbeat/auditbeat.yml
echo "own all the files (so we can run as root, keep them secure)"
#chown -R root:wheel /usr/local/Cellar/auditbeat-full
#chown -R root:wheel /usr/local/Cellar/auditbeat
chown -R root:wheel /usr/local/etc/auditbeat
chown -R root:wheel /usr/local/etc/auditbeat/*
echo "setup and start auditbeat"
# auditbeat setup
echo "setup auditbeat"
./auditbeat setup -e
mv /tmp/co.elastic.auditbeat.plist /usr/local/etc/auditbeat/co.elastic.auditbeat.plist
chmod o-w /usr/local/etc/auditbeat/co.elastic.auditbeat.plist
launchctl load /usr/local/etc/auditbeat/co.elastic.auditbeat.plist

echo "start auditbeat"
launchctl start com.elastic.auditbeat

# maclogbeat
# get latest url
latesturl="$(curl -s https://api.github.com/repos/jaakkoo/macoslogbeat/releases/latest |  grep "browser_download_url.*pkg" | cut -d : -f 2,3 | tr -d \" | awk '{$1=$1};1')"

echo "download macoslogbeat from $latesturl"
cd /tmp/
curl -o "/tmp/macoslogbeat.pkg" -L $latesturl

echo "install macoslogbeat"
installer -pkg macoslogbeat.pkg -target /

echo "configure macoslogbeat"

echo "remove existing config files"
rm /opt/macoslogbeat/*.yml
echo "put config into folder"
filename="/tmp/macoslogbeat.yml"
sed -i '' "s/name\:/name\:\ $(hostname)/" $filename
mv $filename /opt/macoslogbeat/

echo "setup macoslogbeat"
launchctl load /opt/macoslogbeat/install/com.reaktor.macoslogbeat.plist

echo "start macoslogbeat"
launchctl start com.reaktor.macoslogbeat

# to stop macoslogbeat, run this command:  launchctl unload /opt/macoslogbeat/install/com.reaktor.macoslogbeat.plist
