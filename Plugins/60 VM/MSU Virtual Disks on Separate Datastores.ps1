$Title = "VMs disks on multiple storage clusters"
$Header = "VMs disks on multiple storage clusters : [count]"
$Comments = "The following VMs have disks stored on multiple storage clusters"
$Display = "Table"
$Author = "Ed Symanzik, Michigan State University"
$PluginVersion = 1.0
$PluginCategory = "vSphere"

# Start of Settings
$IgnoreDatastores = "ISOs|_ssd_|_local_"
# End of Settings 

#$FullVM = Get-View -ViewType VirtualMachine
#$DatastoreClustersView = Get-View -viewtype StoragePod
#$storageviews = Get-View -ViewType Datastore

$dsclhash = @{}
$DatastoreClustersView | ForEach-Object {
    $dsclhash.($_.MoRef) = $_
}

$dshash = @{}
$storageviews | ForEach-Object {
    $dshash.($_.MoRef) = $_
}

$FullVM | 
    ForEach-Object {
        $dslist = @()
        foreach ($ds in $_.Datastore) {
            if ($IgnoreDatastores -ne "" -and $dshash.$ds.Name -notmatch $IgnoreDatastores) {
                $dslist += $dsclhash.(($dshash.$ds).Parent).Name
            }
        }
        if ($dslist.count -gt 1) {
            $_ | Select-Object @{N="VM";E={$_.Name}},@{N="Datastores";E={($dslist | Sort-Object) -join ", "}}
        }
    } | Sort-Object -Property VM

