<#
#          Script: Managed to Unmanaged disk conversion                                          
#            Date: December 2, 2018                                                                     
#          Author: Prakhar Sharma
#

DESCRIPTION:
This script is used to get input from serverlist.csv and create VM on the basis of that inside the same VNet.
#>

try
{

$CSVPath = Read-Host -Prompt "Provide the path of input csv (like C:\temp\abc.csv)"
$JsonPath = Read-Host -Prompt "Provide the path of input csv (like C:\temp\abc.json)"

#Getting input for username and password
[String]$UserName = Read-Host -Prompt "Enter User Name for Each VM"
[SecureString]$Password = Read-Host -Prompt "Enter Password for Each VM" -AsSecureString

$ResourceGroupName = "Test-RG"
$Location = "WestUS"
$VnetName = "vnet"


#Checking Path for Json and CSV is valid or not
if(!(Test-Path $CSVPath))
{
throw "$CSVPath does not exists"
}

if(!(Test-Path $JsonPath))
{
throw "$JsonPath does not exists"
}

$VMdetails = Import-Csv $CSVPath

foreach($VMdetail in $VMdetails)
{

Write-Output "$($VMdetail.VMHostName) is being deployed"

$ParamObj = @{

"VMName" = $VMdetail.VMName
"VMSize" = $VMdetail.VMSize
"VMHostName" = $VMdetail.VMHostName
"UserName" = $UserName
"Password" = $Password
"Location" = $Location
"NicName" = $VMdetail.nic	
"PublicipName" = $VMdetail.publicip	
"OSdiskName" = $VMdetail.OSdiskName
"IPconfName" = $VMdetail.IPconfName
}

New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location 
New-AzureRmResourceGroupDeployment -Name $($VMdetail.VMName) -ResourceGroupName $ResourceGroupName -Mode Incremental -TemplateFile $JsonPath -TemplateParameterObject $ParamObj -Verbose

} 

}

catch
{

throw $_

}