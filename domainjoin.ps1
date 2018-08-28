##############################################################################
# Add domain join step as per your requirements
# Below is a sample domain join for my instances in AWS.
##############################################################################

#DomainJoin Script
$Hostname = Invoke-RestMethod -Uri http://169.254.169.254/latest/meta-data/instance-id
if ($Hostname.Length -gt 15)
{
  $Hostname = $Hostname.substring(($Hostname.Length) - 15)
}
Write-Host "Renaming to $Hostname"
Rename-Computer -NewName $Hostname
Start-Sleep 5

Set-DefaultAWSRegion -Region AWS_REGION_VALUE_TO_BE_REPLACED;
Set-Variable -name instance_id -value (Invoke-Restmethod -uri http://169.254.169.254/latest/meta-data/instance-id);

New-SSMAssociation -InstanceId $instance_id -Name AWS-JoinDirectoryServiceDomain -Parameter @{directoryId='AWS_DIRECTORYID_TO_BE_REPLACED'; directoryName='yourldap.com'; directoryOU='PROVIDE_COMPLETE_DIRECTORY_OU'; dnsIpAddresses=('IP1', 'IP2',...,'ETC')};
# Alternatively, you can also create one ssm document and use that directly in the command
	
Start-Sleep 5