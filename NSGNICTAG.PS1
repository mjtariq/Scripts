$RGName = Name of your Resource Group
$nsg = Get-AzNetworkSecurityGroup -Name "NSG  Name " -ResourceGroupName "Resource Group of NSG "
$vms = Get-AzVM -Resourcegroup $RGName
foreach ($vm in $vms)
 {
	$tags = (get-azvm -ResourceGroupName $vm.ResourceGroupName -Name $vm.name).tags
 	foreach ($tag in $tags.GetEnumerator())
	 {
		 If (($tag.key -eq "KEY") -and ($tag.value -eq "VALUE"))
			 {
				 $nics = $vm.NetworkProfile.NetworkInterfaces
				 foreach ($nic in $nics)
				 	{
						 $id = (($nic.Id -split '/')[-1])
						$nicp=Get-AzNetworkInterface -Name $ID
						#$nicp.NetworkSecuritygroup = $nsg   
						#$nicp| Set-AZNetworkInterface
						}
				}
		}
}
