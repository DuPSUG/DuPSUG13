<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.148
	 Created on:   	1/30/2018 6:28 PM
	 Created by:   	Maximo Trinidad
	 Organization: 	SAPIEN Technologies, Inc.
	 Filename:     	AzureRMLabPSCore_SetResourceGrpAndStorageGrp.ps1
	===========================================================================
	.DESCRIPTION
		SetResourceGrpAndStorageGrp using AzureRM.Netcore module.
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

##--------------------Start Working with AzureRM--------------------##
function Set-AzureRMResourceGroupAndStorageAccount
{
	[CmdletBinding()]
	Param (
		[string]
		$myResName,
		[string]
		$myResLocation
	)
	
	## -  Need to create a AzureRM ResourceGroup:
	New-AzResourceGroup -Name $myResName -Location $myResLocation;
	
	## - Next Setup a new AzureRm Storage:(Variables Splatting)
	$Params1 = @{
		ResourceGroupName  = $myResName
		Name			   = "$($myResName.ToLower())storeeast01"
		Location		   = $myResLocation
		SkuName		       = 'Standard_GRS'
	};
	New-AzStorageAccount @Params1;
};
Set-AzureRMResourceGroupAndStorageAccount `
										  -myResName $myResGroupName `
										  -myResLocation "EastUS";

## - Caveats:
# 1. ResourceGroup - Must be previously created.
# 2. location - Not 'US East' must be 'EastUS'.
# 3. Account - Name 3-24 characters long and all in lower-case.
# 4. There's no Availability Group set to prevent overcharges.

## ----------------

## - Verify Storage Account was created:
Get-AzStorageAccount -ResourceGroupName $myResGroupName | Format-List;

## - Save-AzureRM for PowerShell Core Linux: (Overrides the existing one)
Save-AzContext -Path "/mnt/c/$AzureEvent/lxPSC_AsubRMprofile.json";
