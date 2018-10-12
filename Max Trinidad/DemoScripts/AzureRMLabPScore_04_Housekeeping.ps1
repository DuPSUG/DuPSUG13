<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.148
	 Created on:   	1/29/2018 7:42 PM
	 Created by:   	Maximo Trinidad
	 Organization: 	SAPIEN Technologies, Inc.
	 Filename:     	AzureRMLabPScore_Housekeeping.ps1
	===========================================================================
	.DESCRIPTION
		AzureRM Housekeeping commands.
#> 

## - For PowerShell Studio console - ##
#region Connect to Azure

$AzureEvent = "FolderNameHere"
#Set-Location "C:\PowerShellChatt\";
Set-Location "/mnt/c/$AzureEvent";
Clear-Host

## - To Login using the JSON profile: Linux
#$AzRmInfo = Import-AzureRmContext -Path "C:\PowerShellChatt\wPSC_AsubRMprofile.json";
$AzRmInfo = Import-AzContext -Path "/mnt/c/$AzureEvent/lxPSC_AsubRMprofile.json";
$AzRmInfo.context `
| Select-Object Environment, Account;

#endregion Connect to Azure

$myResGroupName = 'YourResNameHere';

##---------Start Working with AzureRM--------------------##

## - List all Azure Subscription:
Get-AzSubscription | Select-Object Name;

## - List AzureRM Locations:
Get-AzLocation | select-object location, Displayname

## - List all AzureRm resources:
Get-AzResource `
| Select-Object Name, ResourceGroupName, Location, ResourceType

Get-AzResource `
| Select-Object -unique Name, ResourceGroupName


## - Check VM Status:
Get-AzVM -ResourceGroupName $myResGroupName -status `
| Select-Object Name, PowerState;

## - Or, change "PowerState" to "Status":
Get-AzVM -ResourceGroupName $myResGroupName -status `
| Select-Object Name, @{ label = "Status"; Expression = { $_.PowerState } };

## - Get VM's cloud IPAddress USE for RDP:
Get-AzPublicIpAddress -ResourceGroupName $myResGroupName `
| Select-Object `
				Name, `
				@{ label = "PublicIpAddress"; Expression = { $_.IpAddress } }, `
				@{ label = "AdapterName"; Expression = { $_.IpConfiguration.Id.Split('/')[8] } };


## - Get VM Physical Machines INTERNAL IPAddress:
$IpConfig = `
Get-AzNetworkInterface `
| Select-Object @{ label = "AdapterName"; Expression = { $_.Name } },
				@{ label = "VMname"; Expression = { $_.VirtualMachine.Id.Split('/')[8] } },
				@{ label = "PrivateIpAddress"; Expression = { $_.IpConfigurations.PrivateIpAddress } },
				@{ label = "PrivateIpAllocMethod"; Expression = { $_.IpConfigurations.PrivateIpAllocationMethod } },
				MacAddress;

$IpConfig | Format-Table -AutoSize;

##-----------------------------------##
## - Execute RPD with IP-Address: (Windows Only)
## mstsc /v:<publicIpAddress>
mstsc /v:##CloudVMIpAddress##

##-----------------------------------##
## - Working with active VMs:
## - Shutdown VM's:
Stop-AzVM -name 'W2k16VM1' -ResourceGroupName $myResGroupName;

## - Starting VM's:
Start-AzVM -name 'W2k16VM1' -ResourceGroupName $myResGroupName;

##-----------------------------------##
## - Cleanup All Azure Resources:
$myResGroupName = 'YourResNameHere';
function Clean-MyResources {
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[string]
		$ResourceGroupName
	)
	Write-Host "Start Process Cleanup All Resources - $((Get-Date).ToString('yyyyMMdd_HH:mm'))"
	Remove-AzResourceGroup -Name $ResourceGroupName;
	Write-Host "End of Process - $((Get-Date).ToString('yyyyMMdd_HH:mm'))"
};

Clean-MyResources -ResourceGroupName $myResGroupName;

##-----------------------------------##


