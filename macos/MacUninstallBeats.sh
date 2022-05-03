# auditbeat
echo "stop auditbeat"
launchctl unload /usr/local/etc/auditbeat/co.elastic.auditbeat.plist
echo "uninstall auditbeat"
rm -rf /usr/local/etc/auditbeat
# macoslogbeat
echo "stop macoslogbeat"
launchctl unload /opt/macoslogbeat/install/com.reaktor.macoslogbeat.plist
echo "uninstall macoslogbeat"
pkgutil --forget com.reaktor.macoslogbeat
rm -rf /opt/macoslogbeat
