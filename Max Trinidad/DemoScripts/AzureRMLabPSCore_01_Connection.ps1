<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.145
	 Created on:   	12/12/2017 8:38 PM
	 Created by:   	Maximo Trinidad
	 Organization: 	SAPIEN Technologies, Inc.
	 Filename:   AzureRMLabPsCore_Connection.ps1  	
	===========================================================================
	.DESCRIPTION
		AzureRMSubscription using AzureRM.Netcore module.
#>

## - Change to MyAzureSubscription folder: Linux
$AzureEvent = "FolderNameHere"
Set-Location "/mnt/c/$AzureEvent"
Clear-Host
(Get-Variable PSVersionTable).value.GetEnumerator()

## Windows or Linux connection - one time only

#region SettingCredentials

## - Credential Automation: (PowerShell Way)
$MyUserName = "yourEmailAddress@thatmail.com";
$MyPassword = ConvertTo-SecureString 'My$Pwd01!' -asplaintext -force;
$MyCred = new-object -typename System.Management.Automation.PSCredential `
					 -argumentlist $MyUserName, $MyPassword;

## - Credential Automation: (.NET Way)
#$MyUserName = 'UserName';
#$MyPassword = ConvertTo-SecureString '$MyPwd01!' -asplaintext -force;
#$MyCred = [System.Management.Automation.PSCredential]::new($MyUserName, $MyPassword)

#endregion SettingCredentials

## - Provide Azure Loing prompt:  
Connect-AzAccount
Add-AzAccount

## - Save-AzureRM for PowerShell Core Windows:
Save-AzContext -Path "/mnt/c/$AzureEvent/lxPSC_AsubRMprofile.json";

##---------Start Working with AzureRM--------------------##

## - Reconecting to AzureRM using saved AzureRmContext JSON file(s)
## - To Login using the JSON profile: Linux
$AzRmInfo = Import-AzContext -Path "/mnt/c/$AzureEvent/lxPSC_AsubRMprofile.json";
$AzRmInfo.context | Select-Object Environment, Account;
