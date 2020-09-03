$Title = "ESXi hosts which do not have Lockdown mode enabled"
$Header = "ESXi Hosts with Lockdown Mode not Enabled: [count]"
$Comments = "The following ESXi Hosts do not have lockdown enabled, think about using lockdown as an extra security feature."
$Display = "Table"
$Author = "Alan Renouf"
$PluginVersion = 1.1
$PluginCategory = "vSphere"

# Start of Settings 
# End of Settings 

$VMH | Where-Object {($_.ConnectionState -in @("Connected","Maintenance")) -and 
                      $_.ExtensionData.Summary.Config.Product.Name -eq "VMware ESXi" -and 
                      $_.ExtensionData.Config.AdminDisabled -eq $true} | 
       Select-Object Name, @{N="LockedMode";
                             E={$_.ExtensionData.Config.AdminDisabled}}
