$Title = "NumCpu-Cluster Mismatch"
$Header = "NumCpu-Cluster Mismatch"
$Comments = "Lists VMs where NumCpu doesn't match the cluster size (LG/SM)"
$Display = "Table"
$Author = "Ed Symanzik"
$PluginVersion = 1.0
$PluginCategory = "vSphere"

# Start of Settings 
# End of Settings

# Change Log
## 1.0 : Initial release

foreach ($cluster in (Get-Cluster *-sm,*-lg)) {
    Get-VM -Location $cluster | %{
        $thisvm = $_
        if ((($cluster.Name -like "*-sm") -and ($thisvm.NumCpu -gt 4)) -or (($cluster.Name -like "*-lg") -and ($thisvm.NumCpu -lt 4))) {
            New-Object PsObject -Property @{
                "VM" = $thisvm.Name
                "NumCpu" = $thisvm.NumCpu
                "Cluster" = $cluster.Name
            } | Write-Output
        }
    }
} 