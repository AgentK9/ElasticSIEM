# download winlogbeat
$url = "https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-oss-7.16.2-windows-x86_64.zip"
$zip_path = "c:\Users\Public\Documents\winlogbeat.zip"
$extracted_path = "c:\Program Files\"
$win_beat_folder = $extracted_path + "Winlogbeat"
Invoke-WebRequest -Uri $url -OutFile $zip_path
Expand-Archive $zip_path -DestinationPath $extracted_path

# enable USB device monitoring
$LogName = 'Microsoft-Windows-DriverFrameworks-UserMode/Operational'
wevtutil.exe sl $LogName /enabled:true

# setup winlogbeat
del "c:\Program Files\winlogbeat-*\winlogbeat.yml"
copy "c:\Windows\Temp\winlogbeat.yml" "c:\Program Files\winlogbeat*\winlogbeat.yml"
ren "c:\Program Files\winlogbeat*" $win_beat_folder
cd $win_beat_folder
.\install-service-winlogbeat.ps1
.\winlogbeat.exe setup -e

# start winlogbeat
Start-Service winlogbeat

# download auditbeat
$audit_url = "https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-7.16.2-windows-x86_64.zip"
$audit_zip_path = "c:\Windows\Temp\auditbeat.zip"
$audit_beat_folder = $extracted_path + "Auditbeat"
Invoke-WebRequest -Uri $url -OutFile $audit_zip_path
Expand-Archive $audit_zip_path -DestinationPath $extracted_path

# setup auditbeat
del "c:\Program Files\auditbeat-*\auditbeat.yml"
copy "c:\Windows\Temp\win_auditbeat.yml" "c:\Program Files\auditbeat*\auditbeat.yml"
ren "c:\Program Files\auditbeat*" $audit_beat_folder
cd $audit_beat_folder
.\install-service-auditbeat.ps1
.\winlogbeat.exe setup -e

# start auditbeat
Start-Service auditbeat
