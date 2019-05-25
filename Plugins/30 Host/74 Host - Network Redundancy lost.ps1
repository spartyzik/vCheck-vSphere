$Title = "Network redundancy lost"
$Header = "Network redundancy lost: [count]"
$Comments = "The following Hosts have lost network redundancy"
$Display = "Table"
$Author = "Olivier TABUT"
$PluginVersion = 1.3
$PluginCategory = "vSphere"

# Start of Settings 
$IgnorePnic = @"
    "ESXname", "pNic"
    "vmc-snyphi-h01.nam3.msu.edu", "vmnic0"
    "vmc-snyphi-h01.nam3.msu.edu", "vmnic1"
    "vmc-snyphi-h01.nam3.msu.edu", "vmnic2"
    "vmc-snyphi-h01.nam3.msu.edu", "vmnic3"
    "vmc-snyphi-h02.nam3.msu.edu", "vmnic0"
    "vmc-snyphi-h02.nam3.msu.edu", "vmnic1"
    "vmc-snyphi-h02.nam3.msu.edu", "vmnic2"
    "vmc-snyphi-h02.nam3.msu.edu", "vmnic3"
"@ | ConvertFrom-Csv 
# End of Settings 

$vsList = Get-VirtualSwitch
foreach ($VMHost in $VMH) {
   foreach($pnic in $VMHost.ExtensionData.Config.Network.Pnic){
      $vSw = $vsList | Where-Object {($_.VMHost -eq $VMHost) -and ($_.Nic -contains $pNic.Device)}
      $pnic | 
         Select-Object @{N="ESXname";E={$VMHost.Name}},@{N="pNic";E={$pnic.Device}},@{N="vSwitch";E={$vSw.Name}},@{N="Status";E={if($pnic.LinkSpeed -ne $null){"up"}else{"down"}}} | 
         Where-Object {($_.Status -eq "down") -and ($_.vSwitch -notlike $null)} |
         Compare-Object $IgnorePnic -PassThru |
         Where-Object {$_.SideIndicator -eq "=>"} |
         Select-Object * -ExcludeProperty SideIndicator
   }   
}

## ChangeLog
## 1.3 - Filter out NICs not connected to a vSwitch
