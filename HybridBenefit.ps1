<# 
.Synopsis
A script used to export all Azure VM licensing type in all your Azure Subscriptions.

.DESCRIPTION
A script used to get the list of all Azure virtual machines in all your Azure Subscriptions.
Finally, it will export the report into a csv file in your Azure Cloud Shell storage.


Disclaimer: This script is provided "AS IS" with no warranties. Please use this script at your own discretion 
#>

$azSubs = Get-AzSubscription

foreach ( $azSub in $azSubs ){
    Set-AzContext -Subscription $azSub | Out-Null
    $azSubName = $azSub.Name
    $AzureVM = @()

    foreach ($azVM in Get-AzVM) {
        $props = @{
            VMName = $azVM.Name
            Region = $azVM.Location
            OsType = $azVM.StorageProfile.OsDisk.OsType
            ResourceGroupName = $azVM.ResourceGroupName
        }
        if (!$azVM.LicenseType) {
            $props += @{
                LicenseType = "No_License"
            }
        }
        else {
            $props += @{
                LicenseType = $azVM.LicenseType
            }
        }
    $ServiceObject = New-Object -TypeName PSObject -Property $props
    $AzureVM += $ServiceObject
    }
$AzureVM | Export-Csv -Path "c:\temp\$azSubName-AzVM-Licensing.csv" -NoTypeInformation -force #update the path to store csv
}