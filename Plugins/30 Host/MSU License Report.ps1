$Title = "MSU vCenter License Report"
$Header = "MSU License Report"
$Comments = "Hosts running with no License or an Evaluation License"
$Display = "Table"
$Author = "Ed Symanzik"
$PluginVersion = 1.0
$PluginCategory = "vSphere"

# Start of Settings
# End of Settings

$VMH | Where-Object {-not $_.LicenseKey -or $_.LicenseKey -eq ""} | Select-Object Name,LicenseKey

# Changelog
## 1.0 : Initial Release
