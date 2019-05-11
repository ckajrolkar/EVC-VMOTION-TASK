## Import Module ##
Write-Host "Importing Powershell Module" -ForegroundColor DarkCyan
Get-Module -ListAvailable Vmware* |Import-Module -Verbose
## Start-Trascript For Host Record ## 
Write-Host "Peforming Transcript For Console record"
Start-Transcript
## Import CSV ##
Write-Host "Importing CSV" -ForegroundColor DarkCyan
$data = Import-Csv -Path .\migration.csv
## Assigning ForEach Loop ##
foreach ($object in $data)
{
## Assign Variable 
$vmname = $object.vmname
$hostcluster = $object.hostcluster
# Getting VM as per Vaulue
Write-host "Getting VM Details" -BackgroundColor Cyan
$vm = get-vm $vmname

if ($vm.PowerState -eq "PoweredOn")
{
# Shuting Down VM Gracefully ## 
Write-Host "Starting Shutdown $vm" 
Stop-VMGuest -VM $vm -Confirm:$false
## Sleep Mode ##
Write-Host "Starting Sleep Mode For30 Sec" -BackgroundColor Cyan
Start-Sleep -Seconds 30
## Performing  $vm Migration Of VM to Another VMhostCluster ##
Write-Host "Performing $VM Migration Another VMCluster" -BackgroundColor DarkCyan
$cluster = Get-Cluster -Name $hostcluster
Move-VM  $vm -Destination $cluster -WhatIf
Move-VM  $vm -Destination $cluster
## Sleep Mode ##
Write-Host "Performing Sleep Mode for 15 Sec" -BackgroundColor Cyan
Start-Sleep -Seconds 15
## performing $vm Powered Task ## 
Write-host "Starting $VM" -BackgroundColor Cyan
Start-VM $vm
}

}