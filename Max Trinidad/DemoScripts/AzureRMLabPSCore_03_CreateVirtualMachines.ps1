<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.150
	 Created on:   	4/5/2018 4:20 PM
	 Created by:   	Maximo Trinidad
	 Organization: 	SAPIEN Technologies, Inc.
	 Filename: AzureLabPSCore_CreateVirtualMachines.ps1    	
	===========================================================================
	.DESCRIPTION
		This script uses a shorthand way for creating Virtual machines.
#>

## - For PowerShell Studio console - ##
#region Connect to Azure

$AzureEvent = "FolderNameHere"
Set-Location "/mnt/c/$AzureEvent"
Clear-Host

## - To Login using the JSON profile: Linux
$AzRmInfo = Import-AzContext -Path "/mnt/c/$AzureEvent/lxPSC_AsubRMprofile.json";
$AzRmInfo.context | Select-Object Environment, Account;

#endregion Connect to Azure

$myResGroupName = 'YourResNameHere';

###-------------------------------------------###

## - Set both UserID and Password for Vm(s) to use:
## _ Build Credentials:
$MyUserName = "YourUserName";
$MyPassword = ConvertTo-SecureString 'VM$Passw0rd!' -asplaintext -force;
$MyCred = new-object -typename System.Management.Automation.PSCredential `
					 -argumentlist $MyUserName, $MyPassword;

## - Prepare parameters for VM1:
$vm1Params = @{
	ResourceGroupName    = $myResGroupName
	Name				 = 'W2k16VM1a'
	Location			 = 'eastus'
	ImageName		     = 'Win2016Datacenter'
	PublicIpAddressName  = 'NameHerePublicIp1'
	Credential		     = $MyCred
	OpenPorts		     = 3389
};

## - Create VM1:
# $newVM1 = New-AzureRmVM @vm1Params
New-AzVM @vm1Params -AsJob;

## - Prepare parameters for VM2:
$vm2Params = @{
	ResourceGroupName    = $myResGroupName
	Name				 = 'W2k16VM2a'
	ImageName		     = 'W2016Datacenter'
	VirtualNetworkName   = 'W2k16VM1a'
	SubnetName		     = 'W2k16VM1a'
	PublicIpAddressName  = 'NameHerePublicIp2'
	Credential		     = $MyCred
	OpenPorts		     = 3389
};

## - Create VM2:
#$newVM2 = New-AzureRmVM @vm2Params
New-AzVM @vm2Params -AsJob;

## - Checking result when not using AsJob:
$newVM2.OSProfile | Select-Object ComputerName, AdminUserName
$newVM1.OSProfile | Select-Object ComputerName, AdminUserNa

## - Command to check when using AsJob:
Get-Job;
Receive-Job 1 -Keep;
Receive-Job 2 -Keep;

#region AzureRMImages

## - Check for AzureRM images : (Out-GridView will not work in PSCore6)
Get-AzVMImageOffer -Location 'eastus' -PublisherName 'Canonical' `
| Get-AzVMImageSku | Out-GridView;

Get-AzVMImageOffer -Location 'eastus' -PublisherName 'Canonical' | Get-AzureRmVMImageSku;

Get-AzVMImageOffer -Location 'eastus' -PublisherName 'MicrosoftWindowsDesktop' | Get-AzureRmVMImageSku;

Get-AzVMImage `
				   -Location 'east us' `
				   -PublisherName 'MicrosoftWindowsDesktop' `
				   -Offer 'Windows-10' `
				   -Skus 'RS3-Pro';

## - Using Azure CLI to list available images for above shorthand version: (samples)
az vm image list
az vm image list --publisher 'Microsoft' --all
az vm image list --publisher 'Microsoft'

#endregion AzureRMImages
