$Title = "Snapshots"
$Header = "Snapshots"
$Comments = "Snapshot information"
$Display = "Table"
$Author = "Ed Symanzik"
$PluginVersion = 1.0
$PluginCategory = "vSphere"

# Start of Settings 
# End of Settings

# Change Log
## 1.0 : Initial release

Get-VM -Location| %{ 
        $vmName = $_.Name
        $snapshots = $_ | Get-Snapshot
        if ($snapshots.Count -gt 0) {
            $measure = $snapshots | Measure-Object -Property SizeGB -Sum
            new-object PSObject -Property @{
                VM = $vmName
                Count = $measure.Count
                SizeGB = [int]$measure.Sum
                DaysOld = (New-Timespan -Start ($snapshots | Measure-Object -Property Created -Min).Minimum -End (Get-Date)).Days
            }
        }
    } | 
    Select VM, Count, SizeGB, DaysOld | ft -autosize