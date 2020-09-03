$Title = "Compute/Data Mismatch"
$Header = "Compute/Data Mismatch"
$Comments = "Lists VMs where computer and data are not in the same datacenter"
$Display = "Table"
$Author = "Ed Symanzik"
$PluginVersion = 1.0
$PluginCategory = "vSphere"

# Start of Settings 
# End of Settings

# Change Log
## 1.0 : Initial release

$dshash = @{}
Get-Datastore c?_* | ?{$_.Name -notmatch "iso" } | %{
    if ($_.Name -match "^(..)_*" ) {
        $dshash[$_.Id] = $Matches[1]
    }
} 
$clusters = Get-Cluster "vmc-c?dc-*"
foreach ($cluster in $clusters) {
    $cluster -match "vmc-(..)dc-.*" | out-null
    $computeDC = $Matches[1]
    $vms = get-vm -Location $cluster
    foreach ($vm in $vms) {
        $datastoreDC = $vm.DatastoreIdList | %{if ($dshash[$_]) {$dshash[$_]}} | Sort-Object -Unique
        if ($datastoreDC -notin $computeDC) {
            New-Object PsObject -Property @{
                "VM" = $vm.Name
                "ComputeDC" = $computeDC
                "DataDC" = $datastoreDC
            } | Write-Output
        }
    }
}