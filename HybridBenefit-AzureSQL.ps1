<# 
.Synopsis
A script used to export all Azure VM licensing type in all your Azure Subscriptions.

.REQUIREMENT
An Azure subscription.
A SQL Server VM registered with the SQL IaaS Agent Extension.

.License Type

AHUB for the Azure Hybrid Benefit
PAYG for pay as you go
DR to activate the free HA/DR replica


.DESCRIPTION
A script used to get the list of all Azure virtual machines in all your Azure Subscriptions.
Finally, it will export the report into a csv file in your Azure Cloud Shell storage.


Disclaimer: This script is provided "AS IS" with no warranties. Please use this script at your own discretion 
#>

$azSubs = Get-AzSubscription

foreach ( $azSub in $azSubs ){
    Set-AzContext -Subscription $azSub | Out-Null
    $azSubName = $azSub.Name
    $AzureSQLVM = @()

    foreach ($azSQLVM in Get-AzSQLVM) {
        $props = @{
            VMName = $azSQLVM.Name
            Region = $azSQLVM.Location
            ResourceGroupName = $azSQLVM.ResourceGroupName
			LicenseType = $AzSQLVM.LicenseType
        }
      }
    $ServiceObject = New-Object -TypeName PSObject -Property $props
    $AzureSQLVM += $ServiceObject
    }
$AzureSQLVM | Export-Csv -Path "c:\temp\$azSubName-AzSQLVM-Licensing.csv" -NoTypeInformation -force #update the path to store csv
}