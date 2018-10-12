<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.154
	 Created on:   	8/9/2018 8:00 AM
	 Created by:   	Maximo Trinidad
	 Organization: 	SAPIEN Technologies, Inc.
	 Filename:    Function_Get-AzureRMVMRDPIPAddress.ps1 	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

#region - AzureRMConnect

$AzureEvent = "FolderNameHere"
Set-Location "C:\FolderName\";
#Set-Location "/mnt/c/$AzureEvent";
Clear-Host

## - To Login using the JSON profile: Linux
$AzRmInfo = Import-AzContext -Path "C:\FolderNameHere\wPSC_AsubRMprofile.json";
#$AzRmInfo = Import-AzureRmContext -Path "/mnt/c/$AzureEvent/lxPSC_AsubRMprofile.json";
$AzRmInfo.context `
| Select-Object Environment, Account;

#endregion - AzureRMConnect

$myResGroupName = 'YourResNameHere';

function Get-AzVMIPAddress {
	## - Get VM Physical Machines INTERNAL IPAddress:
	$IpConfig = `
	Get-AzNetworkInterface | `
	Select-Object `
				  @{ label = "AdapterName"; Expression = { $_.Name } },
				  @{ label = "VMname"; Expression = { $_.VirtualMachine.Id.Split('/')[8] } },
				  @{ label = "PrivateIpAddress"; Expression = { $_.IpConfigurations.PrivateIpAddress } },
				  @{ label = "PrivateIpAllocMethod"; Expression = { $_.IpConfigurations.PrivateIpAllocationMethod } },
				  MacAddress;
		
	$IpConfig | Format-Table -AutoSize;
	
}; Get-AzVMIPAddress;

function Get-AzRDPIPAdress {
	## - Get VM's cloud IPAddress USE for RDP:
	Get-AzPublicIpAddress -ResourceGroupName $myResGroupName `
	| Select-Object `
					Name, `
					@{ label = "PublicIpAddress"; Expression = { $_.IpAddress } }, `
					@{ label = "AdapterName"; Expression = { $_.IpConfiguration.Id.Split('/')[8] } };
	
}; Get-AzRDPIPAdress;
